pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'dineshvadlamani/springboot-h2-ci-cd:latest'
        KUBECONFIG = "C:/Users/DINESH/.kube/config"
    }

    stages {
        stage('Verify Kubernetes') {
            steps {
                sh '''
                    echo '🔧 Verifying Kubernetes Contexts...'
                    kubectl config get-contexts || echo '⚠️ No contexts found!'

                    echo '🔄 Switching to docker-desktop context...'
                    kubectl config use-context docker-desktop || echo '✅ Context already set'

                    echo '🔍 Checking Cluster Info...'
                    kubectl cluster-info
                '''
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
