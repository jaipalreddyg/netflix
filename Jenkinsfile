pipeline {
  agent any

  options {
    timestamps()
    disableConcurrentBuilds()
    timeout(time: 60, unit: 'MINUTES')
  }

  parameters {
    booleanParam(name: 'DEPLOY_TO_EKS', defaultValue: true, description: 'Push image to Docker Hub and deploy to EKS')
  }

  environment {
    AWS_REGION = 'ap-south-1'
    CLUSTER_NAME = 'devsecops-netflix-dev'
    DOCKERHUB_IMAGE = 'jaipalreddyg/sample-app'
    HELM_RELEASE = 'sample-app'
    NAMESPACE = 'sample-app'
    APP_NAME = 'sample-app'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        script {
          env.IMAGE_TAG = sh(returnStdout: true, script: 'git rev-parse --short=12 HEAD').trim()
          env.IMAGE_URI = "${env.DOCKERHUB_IMAGE}:${env.IMAGE_TAG}"
        }
        echo "Image: ${env.IMAGE_URI}"
      }
    }

    stage('Build and Unit Test') {
      steps {
        sh 'docker run --rm -v "$WORKSPACE:/workspace" -w /workspace maven:3.9.10-eclipse-temurin-17 mvn -B -ntp clean verify'
      }
    }

    stage('Docker Build') {
      steps {
        sh 'docker build -t "$IMAGE_URI" .'
      }
    }

    stage('Push to Docker Hub') {
      when { expression { return params.DEPLOY_TO_EKS } }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-jaipalreddyg', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_TOKEN')]) {
          sh '''
            echo "$DOCKERHUB_TOKEN" | docker login --username "$DOCKERHUB_USERNAME" --password-stdin
            docker push "$IMAGE_URI"
          '''
        }
      }
    }

    stage('Deploy to EKS') {
      when { expression { return params.DEPLOY_TO_EKS } }
      steps {
        sh '''
          aws eks update-kubeconfig --region "$AWS_REGION" --name "$CLUSTER_NAME"
          kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
          helm upgrade --install "$HELM_RELEASE" helm/sample-app \
            --namespace "$NAMESPACE" \
            --create-namespace \
            --values helm/sample-app/values-prod.yaml \
            --set image.repository="$DOCKERHUB_IMAGE" \
            --set image.tag="$IMAGE_TAG"
        '''
      }
    }

    stage('Rollout Status') {
      when { expression { return params.DEPLOY_TO_EKS } }
      steps {
        sh 'kubectl -n "$NAMESPACE" rollout status deployment/$APP_NAME --timeout=5m'
      }
    }
  }

  post {
    always {
      sh 'docker logout || true'
    }
  }
}
