pipeline{
    agent any
    stages{
        stage('install dependencies'){
            steps{
                sh "npm install"
            }
        }
        stage('build')
            steps{
                sh "npm run build"
            }
        }
        stage('push docker image')
            steps{
                script{
                    docker.withRegistry('','dockerhubCredential'){
                       env.version=sh(returnStdout:true,script:"""
                                 node -pe "require('./package.json').version"
                                  """).trim()
                       env.commit=sh(returnStdout:true,script:"git rev-parse --short HEAD").trim()
                       dockerImage=docker.build "pmarti20/awesomeproject"
                       dockerImage.push("${env.version}.${env.commit}")
                    }
                }
            }
        }
        stage('test image'){
            steps{
                script{
                    docker.image("pmarti20/awesomeproject:{env.version}.${env.commit}").withRun('-p 8090:80'){

                        sh "uname -a"
                        sh "curl -v --silent http://locahost:8090 | grep -i awesomeAngular"
                    }
                }
            }
        }
    }
    post{
        always{
            cleanWs()
        }
    }
}
