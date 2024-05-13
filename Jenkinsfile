pipeline {
    agent any
    stages {
        // stage('Build') {
        //     agent {
        //         docker {
        //             image 'node:18-alpine'
        //             reuseNode true
        //         }
        //     }
        //     steps {
        //         //   ls -la <- show up the content inside dir
        //         //   node --version 
        //         //   npm --version
        //         //   npm ci <- ci/cd equivalent of npm install
        //         sh ''' 
        //             ls -la
        //             node --version
        //             npm --version
        //             npm ci
        //             npm run build
        //             ls -la
        //         '''
        //     }
      
        // }
        stage('Test') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    echo 'Test Stage'
                    test -f build/index.html
                    npm test
                '''
            }
        }
        stage('E2E') {
            agent {
                docker {
                    image 'mcr.microsoft.com/playwright:v1.44.0-jammy'
                    reuseNode true
                }
            }
            steps {
                // DONT
                // npm install -g serve <- will result to permission issues 'permission denied, mkdir '/usr/lib/node_modules/serve''
                // serve -s build

                // DO
                // npm minstall server <- installed locally 
                // node_modules/.bin/serve -s build &
                // wait for sleep 10ms before we exec. playwright test
                sh '''
                    npm install serve
                    node_modules/.bin/serve -s build &
                    sleep 10
                    npx playwright test
                '''
            }
        }

    }
    // exec after stages
    post {
        always {
            junit 'test-results/junit.xml'
        }
    }
}
