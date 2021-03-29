pipeline{
    agent any
    stages{
      stage('install dependencies'){
          steps{
              sh "npm install"
          }
      }
      stage('build'){
          steps{
              sh "npm run build"
          }
      }
      stage('push docker image'){
          steps{
              script{
                  docker.withRegistry('','dockerhubCredential'){
                     env.IMAGE_VERSION=sh(returnStdout:true,script:"""
                               node -pe "require('./package.json').version"
                                """).trim()
                     env.IMAGE_COMMIT=sh(returnStdout:true,script:"git rev-parse --short HEAD").trim()
                     dockerImage=docker.build "pmarti20/awesomeproject","--build-arg COMMIT=${env.IMAGE_COMMIT} --build-arg VERSION=${env.IMAGE_VERSION} -f ./Dockerfile dist/awesomeAngular"
                    dockerImage.push("${env.IMAGE_VERSION}.${env.IMAGE_COMMIT}")
                  }
              }
          }
      }
      stage('test image'){
          steps{
              script{
                  docker.image("pmarti20/awesomeproject:${env.IMAGE_VERSION}.${env.IMAGE_COMMIT}").withRun('-p 8090:80'){
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
