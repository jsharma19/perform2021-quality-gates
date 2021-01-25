@Library('dynatrace@v1.0')
// DO NOT uncomment until 10_01 Lab
/* 
@Library('keptn-library@3.3')
import sh.keptn.Keptn
def keptn = new sh.keptn.Keptn()
*/

def tagMatchRules = [
  [
    meTypes: [
      [meType: 'SERVICE']
    ],
    tags : [
      [context: 'CONTEXTLESS', key: 'app', value: ''],
      [context: 'CONTEXTLESS', key: 'environment', value: 'staging']
    ]
  ]
]

pipeline {
  agent {
    label 'kubegit'
  }

  parameters {
    string(name: 'APP_NAME', defaultValue: '', description: 'The name of the service to deploy.', trim: true)
    string(name: 'TAG_STAGING', defaultValue: '', description: 'The image of the service to deploy.', trim: true)
    string(name: 'VERSION', defaultValue: '', description: 'The version of the service to deploy.', trim: true)
  }

// DO NOT uncomment until 10_01 Lab
/* 
  environment {
    KEPTN_PROJECT = "acl-sockshop"
    KEPTN_SERVICE = "${APP_NAME}"
    KEPTN_STAGE = "staging"
    KEPTN_MONITORING = "dynatrace"
    KEPTN_SHIPYARD = "keptn/e2e-shipyard.yaml"
    KEPTN_SLI = "keptn/e2e-sli.yaml"
    KEPTN_SLO = "keptn/${APP_NAME}-slo.yaml"
    KEPTN_DT_CONF = "keptn/dynatrace.conf.yaml"
    KEPTN_ENDPOINT = credentials('keptn-endpoint')
    KEPTN_API_TOKEN = credentials('keptn-api-token')
    KEPTN_BRIDGE = credentials('keptn-bridge')
  }
*/
  stages {
    stage('Update Deployment and Service specification') {
      steps {
        container('git') {
          withCredentials([usernamePassword(credentialsId: 'git-credentials-acm', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
            sh "git config --global user.email ${env.GITHUB_USER_EMAIL}"
            sh "git clone ${env.GIT_PROTOCOL}://${GIT_USERNAME}:${GIT_PASSWORD}@${env.GIT_ENDPOINT}/${env.GITHUB_ORGANIZATION}/k8s-deploy-staging"
            sh "cd k8s-deploy-staging/ && sed -i 's#image: .*#image: ${env.TAG_STAGING}#' ${env.APP_NAME}.yml"
            sh "cd k8s-deploy-staging/ && git add ${env.APP_NAME}.yml && git commit -m 'Update ${env.APP_NAME} version ${env.VERSION}'"
            sh "cd k8s-deploy-staging/ && git push ${env.GIT_PROTOCOL}://${GIT_USERNAME}:${GIT_PASSWORD}@${env.GIT_ENDPOINT}/${env.GITHUB_ORGANIZATION}/k8s-deploy-staging"
          }
        }
      }
    } // end stage

    stage('Deploy to staging namespace') {
      steps {
        checkout scm
        container('kubectl') {
          sh "kubectl -n staging apply -f ${env.APP_NAME}.yml"
        }
      }
    } // end stage

// DO NOT uncomment until 06_04 Lab
/* 
    stage('DT Deploy Event') {
      steps {
        container("curl") {
          script {
            tagMatchRules[0].tags[0].value = "${env.APP_NAME}"
            def status = pushDynatraceDeploymentEvent (
              tagRule : tagMatchRules,
              customProperties : [
                [key: 'Jenkins Build Number', value: "${env.BUILD_ID}"],
                [key: 'Git commit', value: "${env.GIT_COMMIT}"]
              ]
            )
          }
        }
      }
    } // end stage
*/

// DO NOT uncomment until 10_01 Lab
/* 
    stage('Keptn Init') {
      steps{
        script {
          keptn.keptnInit project:"${KEPTN_PROJECT}", service:"${KEPTN_SERVICE}", stage:"${KEPTN_STAGE}", monitoring:"${KEPTN_MONITORING}", shipyard: "${KEPTN_SHIPYARD}"
          keptn.keptnAddResources("${KEPTN_SLI}",'dynatrace/sli.yaml')
          keptn.keptnAddResources("${KEPTN_SLO}",'slo.yaml')
          keptn.keptnAddResources("${KEPTN_DT_CONF}",'dynatrace/dynatrace.conf.yaml')          
        }
      }
    } // end stage
    
    stage('Staging Warm Up') {
      steps {
        echo "Waiting for the service to start..."
        container('kubectl') {
          script {
            def status = waitForDeployment (
              deploymentName: "${env.APP_NAME}",
              environment: 'staging'
            )
            if(status !=0 ){
              currentBuild.result = 'FAILED'
              error "Deployment did not finish before timeout."
            }
          }
        }
        echo "Running one iteration with one VU to warm up service"  
        container('jmeter') {
          script {
            def status = executeJMeter ( 
              scriptName: "jmeter/front-end_e2e_load.jmx",
              resultsDir: "e2eCheck_${env.APP_NAME}_warmup_${env.VERSION}_${BUILD_NUMBER}",
              serverUrl: "front-end.staging", 
              serverPort: 80,
              checkPath: '/health',
              vuCount: 1,
              loopCount: 1,
              LTN: "e2eCheck_${BUILD_NUMBER}_warmup",
              funcValidation: false,
              avgRtValidation: 4000
            )
            if (status != 0) {
              currentBuild.result = 'FAILED'
              error "Warm up round in staging failed."
            }
          }
        }
      }
    } // end stage

    stage('Run production ready e2e check in staging') {
      steps {
        script {
            keptn.markEvaluationStartTime()
        }
        container('jmeter') {
          script {
            def status = executeJMeter ( 
              scriptName: "jmeter/front-end_e2e_load.jmx",
              resultsDir: "e2eCheck_${env.APP_NAME}_staging_${env.VERSION}_${BUILD_NUMBER}",
              serverUrl: "front-end.staging", 
              serverPort: 80,
              checkPath: '/health',
              vuCount: 10,
              loopCount: 5,
              LTN: "e2eCheck_${BUILD_NUMBER}",
              funcValidation: false,
              avgRtValidation: 4000
            )
            if (status != 0) {
              currentBuild.result = 'FAILED'
              error "Production ready e2e check in staging failed."
            }
          }
        }
        script {
          def keptnContext = keptn.sendStartEvaluationEvent starttime:"", endtime:"" 
          echo "Open Keptns Bridge: ${keptn_bridge}/trace/${keptnContext}"
        }
      }
    } // end stage

    stage('Pipeline Quality Gate') {
      steps {
        script {
          def result = keptn.waitForEvaluationDoneEvent setBuildResult:true, waitTime:'5'
          echo "${result}"
        }
      }
    } // end stage
*/
  } // end stages
} // end pipeline