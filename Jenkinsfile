pipeline {
    agent any

    environment {
        REGISTRY = 'jd2708/demo'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {

        stage('Cloning GitHub') {
            steps {
                git(
                    branch: 'main',
                    credentialsId: 'git_cred',
                    url: 'https://github.com/jayadarshan2708/demo-devops.git'
                )
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Maven') {
            steps {
                sh 'mvn -B -DskipTests=false clean package'
            }
        }

        stage('Unit Tests') {
            steps {
                junit 'target/surefire-reports/*.xml'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${REGISTRY}:${IMAGE_TAG} ."
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker_cred', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                    sh """
                    echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                    """
                    sh "docker push ${REGISTRY}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'EC2_KEY')]) {
                    sh "bash scripts/deploy_via_ssh.sh ${REGISTRY}:${IMAGE_TAG}"
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
		}
	}
}