def commit_id
pipeline {
    agent any
    stages {
        
        stage('preparation') {
            steps {
                checkout scm
                sh "git rev-parse --short HEAD > .git/commit-id"
                script {
                    commit_id = readFile('.git/commit-id').trim()
                }
            }
        }

        stage ('code quality') {
            steps {
                echo 'testing code quality'
               sh "mvn clean verify sonar:sonar \
                    -Dsonar.projectKey=tracker \
                    -Dsonar.host.url=http://localhost:9000 \
                    -Dsonar.login=1002f5c56d276353b1e8a254e23872d5884996a8"
                echo 'code quality test complete'
            }
        }




        stage ('build') {
            steps {
                echo 'building maven workload'
                sh "mvn clean install"
                echo 'build complete'
            }
        }

     
        stage ("image build") {
            steps {
                echo 'building docker image'
                //sh "docker build -t veteron90/tracker:${commit_id} ." 
                sh "sudo docker build -t  192.168.200.132:8082/repository/tracker:${commit_id} ."
                //sh "docker push veteron90/tracker:${commit_id} "
                sh "sudo docker push  192.168.200.132:8082/repository/tracker:${commit_id} "
                echo 'docker image built'
            }
        }

        stage ("Deploy") {
            steps {
                echo 'Deploying in k8s'
                sh "sed -i -r 's|richardchesterwood/k8s-fleetman-position-simulator:release2|position-simulator:${commit_id}|' workloads.yaml"
                sh "kubectl apply -f workloads.yaml"
                sh "kubectl apply -f services.yaml"
                sh "kubectl get all"
                echo 'Deployment complete'
            }
        }
    }
}
