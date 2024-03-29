pipeline {

    agent any

    tools { 
        maven 'my-maven' 
    }
    environment {
        MYSQL_ROOT_LOGIN = credentials('mysql-root-login')
        REGISTRY_LOGIN= credentials('dockerhub')
        REGISTRY_URL="registry-1.docker.io/v1"
        MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_LOGIN_PSW"
        MYSQL_DATABASE="db_example"
        MYSQL_USER="quanndm2906"
        MYSQL_PASSWORD= "$MYSQL_ROOT_LOGIN_PSW"
    }
    stages {

        // stage('Build with Maven') {
        //     steps {
        //         sh 'mvn --version'
        //         sh 'java -version'
        //         sh 'mvn clean package -Dmaven.test.failure.ignore=true'
        //     }
        // }

        stage('Packaging/Pushing image') {

            steps {
                script {
                    sh "docker login -u $REGISTRY_LOGIN_USR -p $REGISTRY_LOGIN_PSW $REGISTRY_URL"
                    sh 'docker build -t quanndm2906/springboot .'
                    sh 'docker push quanndm2906/springboot'
                }
            }
        }

        
        stage('Deploy to DEV') {
            steps {
                echo 'Deploying and cleaning'
                sh 'docker compose down'
                sh "docker login -u $REGISTRY_LOGIN_USR -p $REGISTRY_LOGIN_PSW $REGISTRY_URL"
                sh 'docker pull quanndm2906/springboot'
                sh "docker compose up -d -e MYSQL_PASSWORD=$MYSQL_PASSWORD -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_USER=$MYSQL_USER"
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
