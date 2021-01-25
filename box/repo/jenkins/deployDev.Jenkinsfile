@Library('ace@master') _ 

def tagMatchRules = [
  [
    "meTypes": [
      ["meType": "SERVICE"]
    ],
    tags : [
      ["context": "CONTEXTLESS", "key": "app", "value": "simplenodeservice"],
      ["context": "CONTEXTLESS", "key": "environment", "value": "dev"]
    ]
  ]
]


pipeline {
    parameters {
        string(name: 'APP_NAME', defaultValue: 'simplenodeservice', description: 'The name of the service to deploy.', trim: true)

    }
    agent {
        label 'kubegit'
    }
    stages {
        stage('Update spec') {
            steps {
                script {
                    env.DT_CUSTOM_PROP = readMetaData() + " " + generateDynamicMetaData()
                    env.DT_TAGS = readTags()
                }
                container('git') {
                    withCredentials([usernamePassword(credentialsId: 'git-creds-ace', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        sh "git config --global user.email ${env.GITHUB_USER_EMAIL}"
                        sh "git clone ${env.GIT_PROTOCOL}://${GIT_USERNAME}:${GIT_PASSWORD}@${env.GIT_DOMAIN}/${env.GITHUB_ORGANIZATION}/${env.GIT_REPO}"
                        sh "cd ${env.GIT_REPO}/ && sed 's#value: \"DT_CUSTOM_PROP_PLACEHOLDER\".*#value: \"${env.DT_CUSTOM_PROP}\"#' manifests/${env.APP_NAME}.yml > manifests/dev/${env.APP_NAME}.yml"
                        sh "cd ${env.GIT_REPO}/ && sed -i 's#value: \"DT_TAGS_PLACEHOLDER\".*#value: \"${env.DT_TAGS}\"#' manifests/dev/${env.APP_NAME}.yml"
                        sh "cd ${env.GIT_REPO}/ && sed -i 's#value: \"NAMESPACE_PLACEHOLDER\".*#value: \"dev\"#' manifests/dev/${env.APP_NAME}.yml"
                        sh "cd ${env.GIT_REPO}/ && sed -i 's#image: .*#image: ${env.TAG_STAGING}#' manifests/dev/${env.APP_NAME}.yml"
                        sh "cd ${env.GIT_REPO}/ && git add manifests/dev/${env.APP_NAME}.yml && git commit -m 'Update ${env.APP_NAME} version ${env.BUILD}'"
                        sh "cd ${env.GIT_REPO}/ && git push ${env.GIT_PROTOCOL}://${GIT_USERNAME}:${GIT_PASSWORD}@${env.GIT_DOMAIN}/${env.GITHUB_ORGANIZATION}/${env.GIT_REPO}"
                        sh "rm -rf ${env.GIT_REPO}"
                    }
                }
            }
        }     
        stage('Deploy to dev') {
            steps {
                checkout scm
                container('kubectl') {
                    sh "kubectl -n dev apply -f manifests/dev/${env.APP_NAME}.yml"
                }
            }
        }
        stage('DT send deploy event') {
            steps {
                container("curl") {
                    script {
                        def status = pushDynatraceDeploymentEvent (
                            tagRule : tagMatchRules,
                            deploymentVersion: "${env.BUILD}",
                            customProperties : [
                                [key: 'Jenkins Build Number', value: "${env.BUILD_ID}"],
                                [key: 'Git commit', value: "${env.GIT_COMMIT}"]
                            ]
                        )
                    }
                }
            }
        }

        stage('Run tests') {
            steps {
                build job: "3. Test",
                wait: false,
                parameters: [
                    string(name: 'APP_NAME', value: "${env.APP_NAME}")
                ]
            }
        }  
    }
}
