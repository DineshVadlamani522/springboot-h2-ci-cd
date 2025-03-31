pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'dineshvadlamani/springboot-h2-ci-cd:latest'
        KUBECONFIG = "/var/jenkins_home/.kube/config"  // Adjust for your Jenkins environment
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
                sh 'mvn sonar:sonar -Dsonar.host.url=http://localhost:9001 -Dsonar.login=squ_4cb2c18c4793e45c91bd585619b9f3fb85d1a18e'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: '00c4ca81-d060-4718-85cf-d5897d889470', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
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
                        mkdir -p /var/jenkins_home/.kube
                        cp /root/.kube/config /var/jenkins_home/.kube/config || echo 'No existing kubeconfig found'
                        export KUBECONFIG=/var/jenkins_home/.kube/config
                        kubectl config use-context docker-desktop || echo 'Context already set'
                        kubectl cluster-info
                    """
                }
            }
        }

        stage('Test Kubernetes Access') {
            steps {
                sh 'kubectl get nodes'
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
