// pipeline {
//     agent any
//     stages {
//         // stage('Build') {
//         //     agent {
//         //         docker {
//         //             image 'node:18-alpine'
//         //             reuseNode true
//         //         }
//         //     }
//         //     steps {
//         //         //   ls -la <- show up the content inside dir
//         //         //   node --version 
//         //         //   npm --version
//         //         //   npm ci <- ci/cd equivalent of npm install
//         //         sh ''' 
//         //             ls -la
//         //             node --version
//         //             npm --version
//         //             npm ci
//         //             npm run build
//         //             ls -la
//         //         '''
//         //     }
      
//         // }
//         stage('Test') {
//             agent {
//                 docker {
//                     image 'node:18-alpine'
//                     reuseNode true
//                 }
//             }
//             steps {
//                 sh '''
//                     echo 'Test Stage'
//                     test -f build/index.html
//                     npm test
//                 '''
//             }
//         }
//         stage('E2E') {
//             agent {
//                 docker {
//                     image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
//                     reuseNode true
//                 }
//             }
//             steps {
//                 // DONT
//                 // npm install -g serve <- will result to permission issues 'permission denied, mkdir '/usr/lib/node_modules/serve''
//                 // serve -s build

//                 // DO
//                 // npm minstall server <- installed locally 
//                 // node_modules/.bin/serve -s build &
//                 // wait for sleep 10ms before we exec. playwright test
//                 sh '''
//                     npm install serve
//                     node_modules/.bin/serve -s build &
//                     sleep 10
//                     npx playwright test --reporter=html
//                 '''
//             }
//         }

//     }
//     // exec after stages
//     post {
//         always {
//             junit 'jest-results/junit.xml'
//             // publish report (Make sure that under pipeline syntax )
//             /*
//                 - selected the steps publisHTMLM- Publish HTML Reports
//                 - HTML directory to archive = playwright-report
//                 - IndexPage(s) = index.html
//                 - Report Title = Playwright HTML Report
//                 - Hit Generate Pipeline Script then copy the text
//                 - Paste here
//             */
//             publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright HTML Report', reportTitles: '', useWrapperFileDirectly: true])
//         }
//     }
// }

// Jenkins Parallel with Deploy Stage
pipeline {
    agent any

    environment {
        NETLIFY_SITE_ID = '3ce88dac-de2a-426b-b6a4-e6fc4764a258'
        // Jenkins -> Dashboard -> Manage Jenkins -> Credentials -> System -> Global Cred ->> Add Cred.
        // Kind: Secret Text
        // Scope: Global 
        // Secret: <secret>
        // ID: netlify-token # use to ref to pipeline
        // Then Create
        NETLIFY_AUTH_TOKEN = credentials('netlify-token')
    }

    stages {

        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
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

        stage('Tests') {
            parallel {
                stage('Unit tests') {
                    agent {
                        docker {
                            image 'node:18-alpine'
                            reuseNode true
                        }
                    }

                    steps {
                        sh '''
                            #test -f build/index.html
                            npm test
                        '''
                    }
                    post {
                        always {
                            junit 'jest-results/junit.xml'
                        }
                    }
                }

                stage('E2E') {
                    agent {
                        docker {
                            image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
                            reuseNode true
                        }
                    }

                    steps {
                        sh '''
                            npm install serve
                            node_modules/.bin/serve -s build &
                            sleep 10
                            npx playwright test  --reporter=html
                        '''
                    }

                    post {
                        always {
                            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright HTML Report', reportTitles: '', useWrapperFileDirectly: true])
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    npm install netlify-cli
                    node_modules/.bin/netlify --version
                    echo "Deploying to production. Site ID: $NETLIFY_SITE_ID"
                    node_modules/.bin/netlify status
                    node_modules/.bin/netlify deploy --dir=build --prod
                '''
            }
        }

        stage('Production E2E') {
            agent {
                docker {
                    image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
                    reuseNode true
                }
            }

            environment {
                CI_ENVIRONMENT_URL = 'https://magical-begonia-ae91d0.netlify.app'
            }

            steps {
                sh '''
                    npx playwright test  --reporter=html
                '''
            }

            post {
                always {
                    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright HTML Production Report', reportTitles: '', useWrapperFileDirectly: true])
                }
            }
        }
    }
}
