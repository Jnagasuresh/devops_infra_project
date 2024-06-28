// this jenkinsfile is for Eureka microservice

pipeline{
    agent {
        label 'k8s-slave'
    }
    tools {
        maven 'Maven-3.8.8'
        jdk 'JDK-17'
    }
    environment{
        APPLICATION_NAME = "eureka"
    }
    stages {
        stage ('Build') {
            // This step will take care of building the application
            steps {
                echo "Building the ${APPLICATION_NAME} Application"
                // mvn command
                sh 'mvn clean package -DskipTests=true'
                archiveArtifacts artifacts: 'target/*.jar' //archiving the artifacts
            }
        }
        stage ('Unit Tests'){
            steps {
                echo "Executing Unit tests for ${APPLICATION_NAME}  Application"
                sh 'mvn test'
            }
             post {
                always {
                    junit  'target/surefire-reports/*.xml'
                    jacoco execPattern: 'target/jacoco.exec'
                }
               }
        }
       
    }
}