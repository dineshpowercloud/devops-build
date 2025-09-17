pipeline {
  agent any
  environment {
    DOCKER_REPO = "${env.DOCKER_USER ?: 'dineshpowercloud'}/devops-app"
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Build & Tag') {
      steps {
        script {
          def branchTag = (env.BRANCH_NAME == 'master') ? 'prod' : 'dev'
          sh "docker build -t ${DOCKER_REPO}:${GIT_COMMIT} ."
          sh "docker tag ${DOCKER_REPO}:${GIT_COMMIT} ${DOCKER_REPO}:${branchTag}"
        }
      }
    }
    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
          sh '''
            echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
            docker push ${DOCKER_REPO}:${GIT_COMMIT}
            docker push ${DOCKER_REPO}:$( [ "$BRANCH_NAME" = "master" ] && echo prod || echo dev )
          '''
        }
      }
    }
    stage('Deploy to EC2') {
      when {
        anyOf { branch 'dev'; branch 'master' }
      }
      steps {
        script {
          def targetTag = (env.BRANCH_NAME == 'master') ? 'prod' : 'dev'
          sshagent (credentials: ['ec2-ssh']) {
            sh "ssh -o StrictHostKeyChecking=no ubuntu@3.208.8.110 'docker pull ${DOCKER_REPO}:${targetTag} && docker stop web || true && docker rm web || true && docker run -d --name web -p 80:80 --restart unless-stopped ${DOCKER_REPO}:${targetTag}'"
          }
        }
      }
    }
  }
}
