// this jenkinsfile is for Eureka microservice

pipeline {
    agent {
        label 'k8s-slave'
    }
    tools {
        maven 'Maven-3.8.8'
        jdk 'JDK-17'
    }
    environment{
        APPLICATION_NAME = "eureka"
        POM_VERSION = readMavenPom().getVersion()
        POM_PACKAGING = readMavenPom().getPackaging()
        SONAR_URL = "http://34.73.212.154:9000"
        SONAR_TOKEN = credentials('sonar_creds')
        DOCKER_HUB ="docker.io/jnagasuresh"
        DOCKER_CREDS = credentials('docker_creds')
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
        // stage ('Unit Tests'){
        //     steps {
        //         echo "Executing Unit tests for ${APPLICATION_NAME}  Application"
        //         sh 'mvn test'
        //     }
        //      post {
        //         always {
        //             junit  'target/surefire-reports/*.xml'
        //             jacoco execPattern: 'target/jacoco.exec'
        //         }
        //        }
        // }
        stage ('sonar') {
            // sqa_3aa5ca02bb917b5a93a398c021068ba311697d5c
            steps {
                echo "StartingSonar Scans with QualityGates"
                // Before we go to tnext step, install sonarqube plugin
                // next goto manage jenkins > configure > sonarquebe > give url and token for sonar
                withSonarQubeEnv('SonarQube'){ // SonarQube is the name that we configured in manage jenkins > Sonarqube
                    sh """
                    echo "Starting Sonar scan"
                    mvn sonar:sonar \
                        -Dsonar.projectKey=i27-eureka \
                        -Dsonar.host.url=${env.SONAR_URL} \
                        -Dsonar.login=${SONAR_TOKEN}
                    """
                }
                timeout (time:2, unit:'MINUTES'){
                    script {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        
        }
        stage ("Docker Build and Push") {
             steps {
                echo "Starting Docker build stage"
                sh """
                ls -la
                pwd
                cp ${WORKSPACE}/target/i27-${env.APPLICATION_NAME}-${env.POM_VERSION}.${env.POM_PACKAGING} ./.cicd/
                echo "Listing Files in .cicd folder"
                ls -la ./.cicd/
                echo "**************************** Building Docker Image ****************************"
                docker build --force-rm --no-cache --build-arg JAR_SOURCE=i27-${env.APPLICATION_NAME}-${env.POM_VERSION}.${env.POM_PACKAGING} -t ${env.DOCKER_HUB}/${env.APPLICATION_NAME}:${GIT_COMMIT} ./.cicd
                docker images
                echo "**************************** Login to Docke Repo ****************************"
                docker login -u ${DOCKER_CREDS_USR} -p ${DOCKER_CREDS_PSW}
                echo "**************************** Docker Push ****************************"
                docker push ${env.DOCKER_HUB}/${env.APPLICATION_NAME}:${GIT_COMMIT}
                """
            }
            // steps {
            //     echo "Starting Docker build stage"
            //     sh """
            //     ls -la
            //     pwd
            //     cp ${WORKSPACE}/target/i27-${env.APPLICATION_NAME}-${env.POM_VERSION}.${env.POM_PACKAGING} ./.cicd/
            //     echo "Listing Files in .cicd folder"
            //     ls -la ./.cicd/
            //     echo "************************Building Docker Image **************************"
            //     docker build --force-rm --no-cache --build-arg=i27-${env.APPLICATION_NAME}-${env.POM_VERSION}.${env.POM_PACKAGING} -t ${env.DOCKER_HUB}/${env.APPLICATION_NAME}:${GIT_COMMIT} ./.cicd
            //     docker images
            //     echo "***************** Login to Docker Repo *********************"
            //     docker login -u ${DOCKER_CREDS_USR} -p ${DOCKER_CREDS_PSW}
            //     echo "*******************Docker push*****************"
            //     docker push ${env.DOCKER_HUB}/${env.APPLICATION_NAME}:${GIT_COMMIT}
            //     """
            // }
        }
        stage ('Deploy To Dev')
        {
             steps {
                echo "**************************** Deploying to Dev Environment ****************************"
                withCredentials([usernamePassword(credentialsId: 'maha_docker_vm_creds', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    // some block
                    // With this block, the slave will be connecting to the docker-server using ssh 
                    // and will execute what all commands i want to go for 

                   // sshpass -p password ssh -o StrictHostKeyChecking=no username@hostip command_to_run
                   sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${docker_server_ip} hostname -i"
                   // sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${docker_server_ip} hostname -i"
                   // docker run -d -p hp:cp --name containername image:tagname
                   // docker run -d -p 5761:8761 --name ${env.APPLICATION_NAME}-dev ${env.DOCKER_HUB}/${env.APPLICATION_NAME}:${GIT_COMMIT}
                   script {
                    // pull the image onthe docker server
                    sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${docker_server_ip} docker pull ${env.DOCKER_HUB}/${env.APPLICATION_NAME}:${GIT_COMMIT}"
                    try {
                        // Stop the container
                        sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${docker_server_ip} docker stop  ${env.APPLICATION_NAME}-v2"

                        // Remove the container 
                        sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${docker_server_ip} docker rm ${env.APPLICATION_NAME}-v2"

                    } catch (err) {
                        echo "Error caught: $err"
                    }
                     echo "Creating the Container"
                     sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${docker_server_ip} docker run -d -p 5761:8761 --name ${env.APPLICATION_NAME}-v2 ${env.DOCKER_HUB}/${env.APPLICATION_NAME}:${GIT_COMMIT}"
                   }
                 
                }
            }
            // steps {
            //     echo "*************************Deploying to Dev Environment *********************"
            //     withCredentials([usernamePassword(credentialsId: 'maha_docker_vm_creds', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]){
            //         // with this block, the slave will be connecting to the docker-server using ssh
            //         // and will execute that all commands I want to go for
            //         // sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${docker_server_ip} hostname -i"
            //         //docker run -d -p 5761:8761 --name ${env.APPLICATION_NAME}-dev ${env.DOCKER_HUB}/${env.APPLICATION_NAME}:${GIT_COMMIT}
            //         echo "Creating the Container"
            //         sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${docker_server_ip} docker run -d -p 5761:8761 --name ${env.APPLICATION_NAME}-dev1 ${env.DOCKER_HUB}/${env.APPLICATION_NAME}:${GIT_COMMIT}"
            //     }
            // }
        }
         stage ('Deploy To Test')
        {
             steps {
                echo "**************************** Deploying to Test Environment ****************************"
                withCredentials([usernamePassword(credentialsId: 'maha_docker_vm_creds', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                   
                   sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${docker_server_ip} hostname -i"
                   
                   script {
                    // pull the image onthe docker server
                    sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${docker_server_ip} docker pull ${env.DOCKER_HUB}/${env.APPLICATION_NAME}:${GIT_COMMIT}"
                    try {
                        // Stop the container
                        sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${docker_server_ip} docker stop  ${env.APPLICATION_NAME}-test"

                        // Remove the container 
                        sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${docker_server_ip} docker rm ${env.APPLICATION_NAME}-test"

                    } catch (err) {
                        echo "Error caught: $err"
                    }
                     echo "Creating the Container"
                     sh "sshpass -p ${PASSWORD} ssh -o StrictHostKeyChecking=no ${USERNAME}@${docker_server_ip} docker run -d -p 6761:8761 --name ${env.APPLICATION_NAME}-test ${env.DOCKER_HUB}/${env.APPLICATION_NAME}:${GIT_COMMIT}"
                   }
                 
                }
            }
            
        }
    //    stage ('Docker Format') {
    //     steps {
    //         // i27-eureka-0.0.1-SNAPSHOT.jar
    //         // Install pipeline Utility Steps plugin before we run this stae
    //         //current format
    //         echo "The current Format is : i27-${env.APPLICATION_NAME}-${env.POM_VERSION}.${env.POM_PACKAGING}"
    //         echo "Custom format is : ${env.APPLICATION_NAME}-${currentBuild.number}-${BRANCH_NAME}.$env.POM_PACKAGING"
    //     }
    //    }

    
       
    }
}

/*
 there are 3 ways sonar implementation can be done
 1. pom.xml ---> Sonar properties
 2. sonar.properties ---> with sonar properties
 3. own method ----> with sonar properties

*/

//Sonar scan command
// mvn sonar:sonar user/password or token and where my sonar (host url) is and project key