pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'dineshvadlamani/springboot-h2-ci-cd:latest'
        KUBECONFIG = "C:/Users/DINESH/.kube/config"  // Correct kubeconfig path for Windows
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'feature',
                    credentialsId: 'github-credentials',
                    url: 'https://github.com/DineshVadlamani522/springboot-h2-ci-cd'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                sh 'mvn sonar:sonar -Dsonar.host.url=http://localhost:9001 -Dsonar.login=squ_1b8ede8f6c600e0336ce3da0af9d72b8f7279731'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: '00c4ca81-d060-4718-85cf-d5897d889470', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    sh "docker build -t ${DOCKER_IMAGE} ."
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Setup Kubernetes Context') {
            steps {
                script {
                    sh """
                        echo 'Setting Kubernetes Config...'
                        export KUBECONFIG=${KUBECONFIG}
                        
                        # Check if docker-desktop context exists
                        kubectl config get-contexts | grep 'docker-desktop' || echo 'No docker-desktop context found'
                        
                        # Switch context only if it exists
                        kubectl config use-context docker-desktop || echo 'Context already set'
                        
                        # Verify cluster connectivity
                        kubectl cluster-info || echo 'Cluster not reachable'
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
