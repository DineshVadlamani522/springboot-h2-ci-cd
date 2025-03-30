pipeline {
    agent any

    environment {
        HOME = '/root' // Ensure this is correct for your Jenkins agent
        KUBECONFIG = "${HOME}/.kube/config"
        DOCKER_IMAGE = 'dineshvadlamani/springboot-h2-ci-cd:latest'
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

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    echo "Setting Kubernetes Config..."
                    export KUBECONFIG=$HOME/.kube/config
                    kubectl config use-context docker-desktop
                    kubectl cluster-info
                    kubectl get nodes
                    echo "Applying deployment..."
                    kubectl apply -f deployment.yaml --validate=false
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    echo "Checking Kubernetes deployment..."
                    kubectl get pods -o wide
                    kubectl get services -o wide
                '''
            }
        }
    }
}
