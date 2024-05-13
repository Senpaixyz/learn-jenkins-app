pipeline {
    agent any

    stages {
        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                //   ls -la <- show up the content inside dir
                //   node --version 
                //   npm --version
                //   npm ci <- ci/cd equivalent of npm install
                sh ''' 
                    ls -la
                    node --version
                    npm --version
                    npm ci
                    npm run build
                    ls -la
                '''
            }
      
        }
        stage('Test') {
            steps {
                sh '''
                    echo 'Test Stage'
                    test -f build/index.html
                    npm test
                '''
            }
        }

    }
}
