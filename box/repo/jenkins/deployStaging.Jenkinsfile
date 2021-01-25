@Library('ace@master') _ 

def tagMatchRules = [
  [
    "meTypes": [
      ["meType": "SERVICE"]
    ],
    tags : [
      ["context": "CONTEXTLESS", "key": "app", "value": "simplenodeservice"],
      ["context": "CONTEXTLESS", "key": "environment", "value": "staging"]
    ]
  ]
]

def mzContitions = [
    [
        key: [ attribute: 'SERVICE_TAGS' ],
        comparisonInfo: [ type: 'TAG', operator: 'EQUALS',
            value: [ context: 'CONTEXTLESS', key: 'project', value: 'simpleproject' ],
            negate: false
        ]
    ],
    [
        key: [ attribute: 'PROCESS_GROUP_PREDEFINED_METADATA', dynamicKey: 'KUBERNETES_NAMESPACE', type: 'PROCESS_PREDEFINED_METADATA_KEY' ],
        comparisonInfo: [ type: 'STRING', operator: 'EQUALS', value: 'staging', negate: false, caseSensitive: false ]
    ]
]

def dashboardTileRules = [
    [
        name : 'Service health', tileType : 'SERVICES', configured : true, filterConfig: null, chartVisible: true,
        bounds : [ top: 38, left : 0, width: 304, height: 304 ],
        tileFilter : [ timeframe : null, managementZone : null ]
            
    ],
    [
        name : 'Custom chart', tileType : 'CUSTOM_CHARTING', configured : true, chartVisible: true,
        bounds : [ top: 38, left : 342, width: 494, height: 304 ],
        tileFilter : [ timeframe : null, managementZone : null ],
        filterConfig : [ type : 'MIXED', customName: 'Response time', defaultName: 'Custom chart', 
            chartConfig : [
                legendShown : true, type : 'TIMESERIES', resultMetadata : [:],
                series : [
                    [ metric: 'builtin:service.response.time', aggregation: 'AVG', percentile: null, type : 'BAR', entityType : 'SERVICE', dimensions : [], sortAscending : false, sortColumn : true, aggregationRate : 'TOTAL' ]
                ],
            ],
        filtersPerEntityType: [:]
        ]
    ],
    [
        name : 'Custom chart', tileType : 'CUSTOM_CHARTING', configured : true, chartVisible: true,
        bounds : [ top: 38, left : 874, width: 494, height: 304 ],
        tileFilter : [ timeframe : null, managementZone : null ],
        filterConfig : [ type : 'MIXED', customName: 'Failure rate (any  errors)', defaultName: 'Custom chart', 
            chartConfig : [
                legendShown : true, type : 'TIMESERIES', resultMetadata : [:],
                series : [
                    [ metric: 'builtin:service.errors.total.rate', aggregation: 'AVG', percentile: null, type : 'BAR', entityType : 'SERVICE', dimensions : [], sortAscending : false, sortColumn : true, aggregationRate : 'TOTAL' ]
                ],
            ],
        filtersPerEntityType: [:]
        ]
    ]
]

pipeline {
    parameters {
        string(name: 'APP_NAME', defaultValue: 'simplenodeservice', description: 'The name of the service to deploy.', trim: true)
        string(name: 'TAG_STAGING', defaultValue: '', description: 'The image of the service to deploy.', trim: true)
        string(name: 'BUILD', defaultValue: '', description: 'The version of the service to deploy.', trim: true)
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
                        sh "cd ${env.GIT_REPO}/ && sed 's#value: \"DT_CUSTOM_PROP_PLACEHOLDER\".*#value: \"${env.DT_CUSTOM_PROP}\"#' manifests/${env.APP_NAME}.yml > manifests/staging/${env.APP_NAME}.yml"
                        sh "cd ${env.GIT_REPO}/ && sed -i 's#value: \"DT_TAGS_PLACEHOLDER\".*#value: \"${env.DT_TAGS}\"#' manifests/staging/${env.APP_NAME}.yml"
                        sh "cd ${env.GIT_REPO}/ && sed -i 's#value: \"NAMESPACE_PLACEHOLDER\".*#value: \"staging\"#' manifests/staging/${env.APP_NAME}.yml"
                        sh "cd ${env.GIT_REPO}/ && sed -i 's#image: .*#image: ${env.TAG_STAGING}#' manifests/staging/${env.APP_NAME}.yml"
                        sh "cd ${env.GIT_REPO}/ && git add manifests/staging/${env.APP_NAME}.yml && git commit -m 'Update ${env.APP_NAME} version ${env.BUILD}'"
                        sh "cd ${env.GIT_REPO}/ && git push ${env.GIT_PROTOCOL}://${GIT_USERNAME}:${GIT_PASSWORD}@${env.GIT_DOMAIN}/${env.GITHUB_ORGANIZATION}/${env.GIT_REPO}"
                        sh "rm -rf ${env.GIT_REPO}"
                    }
                }
            }
        }     
        stage('Deploy to staging') {
            steps {
                checkout scm
                container('kubectl') {
                    sh "kubectl -n staging apply -f manifests/staging/${env.APP_NAME}.yml"
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
