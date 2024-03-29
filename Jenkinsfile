pipeline {

    agent any

    tools { 
        maven 'my-maven' 
    }
    environment {
        MYSQL_ROOT_LOGIN = credentials('mysql-root-login')
        MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_LOGIN_PSW}"
        MYSQL_DATABASE="db_example"
        MYSQL_USER="quanndm2906"
        MYSQL_PASSWORD= "${MYSQL_ROOT_LOGIN_PSW}"
    }
    stages {

        // stage('Build with Maven') {
        //     steps {
        //         sh 'mvn --version'
        //         sh 'java -version'
        //         sh 'mvn clean package -Dmaven.test.failure.ignore=true'
        //     }
        // }

        stage('Packaging/Pushing imagae') {

            steps {
                withDockerRegistry(credentialsId: 'dockerhub', url: 'https://index.docker.io/v2/') {
                    def dockerimg = docker.build("quanndm2906/springboot")
                    dockerimg.push()
                }
            }
        }

        
        stage('Deploy to DEV') {
            steps {
                echo 'Deploying and cleaning'
                sh 'docker compose down'
                withDockerRegistry(credentialsId: 'dockerhub', url: 'https://index.docker.io/v2/') {
                    sh 'docker pull quanndm2906/springboot'
                }
                sh "docker compose up -d -e MYSQL_PASSWORD=${MYSQL_PASSWORD} -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} -e MYSQL_DATABASE=${MYSQL_DATABASE} -e MYSQL_USER=${MYSQL_USER}"
            }
        }
 
    }
    post {
        // Clean after build
        always {
            cleanWs()
        }
    }
}
