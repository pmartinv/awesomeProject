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
                     version=sh(returnStdout:true,script:"""
                               node -pe "require('./package.json').version"
                                """).trim()
                     commit=sh(returnStdout:true,script:"git rev-parse --short HEAD").trim()
                     dockerImage=docker.build "pmarti20/awesomeproject","--build-arg COMMIT=$commit --build-arg VERSION=$version -f ./Dockerfile dist/awesomeAngular"
                     dockerImage.push("$version.$commit")
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
