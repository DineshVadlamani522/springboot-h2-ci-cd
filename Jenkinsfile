pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'dineshvadlamani/springboot-h2-ci-cd:latest'
        KUBECONFIG = "/root/.kube/config"  // Use /root/.kube/config if Jenkins is in Docker
    }

    stages {
        stage('Setup Kubernetes Context') {
            steps {
                script {
                    sh """
                        echo 'Setting Kubernetes Config...'
                        kubectl config use-context docker-desktop || echo 'Context already set'
                        kubectl cluster-info
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yaml --validate=false'
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'kubectl get pods'
                sh 'kubectl get services'
            }
        }
    }
}
