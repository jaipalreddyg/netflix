pipeline {
  agent any

  options {
    buildDiscarder(logRotator(numToKeepStr: '20'))
    disableConcurrentBuilds()
    timeout(time: 60, unit: 'MINUTES')
    timestamps()
  }

  parameters {
    booleanParam(name: 'RUN_SONAR', defaultValue: false, description: 'Run SonarQube only if Jenkins has sonar-token and sonarqube-prod configured')
    booleanParam(name: 'DEPLOY_TO_EKS', defaultValue: true, description: 'Push image to Docker Hub and deploy to EKS with Helm')
  }

  environment {
    AWS_REGION   = 'ap-south-1'
    CLUSTER_NAME = 'project06-prod'
    DOCKERHUB_NAMESPACE = 'jaipalreddyg'
    DOCKERHUB_REPO      = 'sample-app'
    HELM_RELEASE = 'sample-app'
    NAMESPACE    = 'sample-app'
    APP_NAME     = 'sample-app'
    HELM_EXE     = 'C:\\Users\\jaipa\\AppData\\Local\\helm\\windows-amd64\\helm.exe'
    TRIVY_EXE    = 'C:\\Users\\jaipa\\AppData\\Local\\Microsoft\\WinGet\\Packages\\AquaSecurity.Trivy_Microsoft.Winget.Source_8wekyb3d8bbwe\\trivy.exe'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        script {
          env.IMAGE_TAG = powershell(returnStdout: true, script: 'try { git rev-parse --short=12 HEAD } catch { Get-Date -Format yyyyMMddHHmmss }').trim()
          env.IMAGE_REPO = "${env.DOCKERHUB_NAMESPACE}/${env.DOCKERHUB_REPO}"
          env.IMAGE_URI = "${env.IMAGE_REPO}:${env.IMAGE_TAG}"
        }
        echo "Image: ${env.IMAGE_URI}"
      }
    }

    stage('Build and Unit Test') {
      steps {
        powershell 'docker run --rm -v "${env:WORKSPACE}:/workspace" -w /workspace maven:3.9.10-eclipse-temurin-17 mvn -B -ntp clean verify'
      }
      post {
        always {
          junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml'
          archiveArtifacts allowEmptyArchive: true, artifacts: 'target/*.jar,target/site/jacoco/**'
        }
      }
    }

    stage('SonarQube') {
      when { expression { return params.RUN_SONAR } }
      steps {
        withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
          withSonarQubeEnv('sonarqube-prod') {
            powershell 'docker run --rm -e SONAR_TOKEN="$env:SONAR_TOKEN" -v "${env:WORKSPACE}:/workspace" -w /workspace maven:3.9.10-eclipse-temurin-17 mvn -B -ntp sonar:sonar -Dsonar.token="$env:SONAR_TOKEN"'
          }
        }
      }
    }

    stage('Quality Gate') {
      when { expression { return params.RUN_SONAR } }
      steps {
        timeout(time: 10, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: true
        }
      }
    }

    stage('Docker Build') {
      steps {
        powershell 'docker build --pull --label org.opencontainers.image.revision="$env:GIT_COMMIT" -t "$env:IMAGE_URI" .'
      }
    }

    stage('Trivy Scan') {
      steps {
        powershell '& "$env:TRIVY_EXE" image --exit-code 1 --severity CRITICAL,HIGH "$env:IMAGE_URI"'
      }
    }

    stage('Push to Docker Hub') {
      when { expression { return params.DEPLOY_TO_EKS } }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-jaipalreddyg', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_TOKEN')]) {
          powershell '''
            $ErrorActionPreference = 'Stop'
            $env:DOCKERHUB_TOKEN | docker login --username "$env:DOCKERHUB_USERNAME" --password-stdin
            docker push "$env:IMAGE_URI"
          '''
        }
      }
    }

    stage('Deploy to EKS') {
      when { expression { return params.DEPLOY_TO_EKS } }
      steps {
        powershell '''
          $ErrorActionPreference = 'Stop'
          aws eks update-kubeconfig --region "$env:AWS_REGION" --name "$env:CLUSTER_NAME"
          kubectl create namespace "$env:NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
          kubectl label namespace "$env:NAMESPACE" app.kubernetes.io/managed-by=Helm --overwrite
          kubectl annotate namespace "$env:NAMESPACE" meta.helm.sh/release-name="$env:HELM_RELEASE" meta.helm.sh/release-namespace="$env:NAMESPACE" --overwrite
          kubectl -n "$env:NAMESPACE" create secret generic sample-app-secrets --from-literal=SPRING_PROFILES_ACTIVE=prod --dry-run=client -o yaml | kubectl apply -f -
          & "$env:HELM_EXE" lint helm/sample-app --values helm/sample-app/values-prod.yaml
          & "$env:HELM_EXE" upgrade --install "$env:HELM_RELEASE" helm/sample-app --namespace "$env:NAMESPACE" --create-namespace --values helm/sample-app/values-prod.yaml --set "image.repository=$env:IMAGE_REPO" --set "image.tag=$env:IMAGE_TAG" --atomic --wait --timeout 10m --history-max 20
        '''
      }
    }

    stage('Rollout Status') {
      when { expression { return params.DEPLOY_TO_EKS } }
      steps {
        powershell 'kubectl -n "$env:NAMESPACE" rollout status deployment/$env:APP_NAME --timeout=5m'
      }
    }

    stage('Smoke Test') {
      when { expression { return params.DEPLOY_TO_EKS } }
      steps {
        powershell '''
          $ErrorActionPreference = 'Stop'
          $pod = kubectl -n "$env:NAMESPACE" get pod -l "app.kubernetes.io/name=$env:APP_NAME" -o jsonpath='{.items[0].metadata.name}'
          kubectl -n "$env:NAMESPACE" exec $pod -- wget -qO- http://127.0.0.1:8000/
        '''
      }
    }

    stage('Deployment Summary') {
      when { expression { return params.DEPLOY_TO_EKS } }
      steps {
        powershell '''
          kubectl -n "$env:NAMESPACE" get deploy,pod,svc,hpa,pdb -o wide
          & "$env:HELM_EXE" -n "$env:NAMESPACE" history "$env:HELM_RELEASE"
        '''
      }
    }
  }

  post {
    always {
      powershell 'docker logout; exit 0'
    }
  }
}