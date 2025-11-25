pipeline {
    agent any

    environment {
        REGISTRY = "jd2708/demo"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        credentialsId: 'git_cred',
                        url: 'https://github.com/jayadarshan2708/demo-devops.git'
                    ]]
                ])
            }
        }

        stage('Build Maven Project') {
            steps {
                dir('app'){
			sh'mvn -B -DskipTests=false clean package'
		}
            }
        }

        stage('Unit Tests') {
            steps {
		dir('app'){
			sh 'mvn test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${REGISTRY}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'docker_cred', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')
                ]) {
                    sh '''
                        echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                    '''
                    sh "docker push ${REGISTRY}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                withCredentials([
                    sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'EC2_KEY')
                ]) {
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
