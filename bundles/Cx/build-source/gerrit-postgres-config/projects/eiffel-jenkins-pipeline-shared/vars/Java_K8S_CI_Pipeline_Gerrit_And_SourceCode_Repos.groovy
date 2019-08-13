//
//   Copyright 2019 Ericsson AB.
//   For a full list of individual contributors, please see the commit history.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
// ############################################################################
// Java_K8S_CI_Pipeline_Gerrit_And_SourceCode_Repos.groovy
//
// Build/test steps executed in docker containers in Kubernetes pods. Jenkins
// Slaves (PODs) will be spawned for build activities
//
// Author: michael.frick@ericsson.com
//
// #############################################################################
// Pre-Merge Pipeline with Wrapper in Gerrit and SourceCode in GITHUB:
//   GITHUB_REPO must be defined as inparam to pipeline
// ##################
//        - Poller will update gerrit repo build_info.yaml file with GITHUB
//          SourceCode repo hash to build.
//        - When Github poller pushed the commit to gerrit repo, Gerrit event
//          will trigger pipeline (Jenkinsfile) in gerrit repo
//        - Pipeline will identify Pre-merge (patchset for review in Gerrit) and
//          execute build test steps, but no artifact/image uploads
//        - Success will update Gerrit Review Verified with "+1", else "-1".
//          Now Manual Gerrit Code review (+2) is needed.
//
// GITHUB Poller update GITHUB sourcecode repo with commit hash in
// build_info.yml file, push commit for Gerrit Review GERRIT_EVENT_TYPE:
// patchset-created
//        |
// Gerrit Event
//        |
//   Gerrit repo                 Source Code repo
//    build_info.yml including -> hash -> checkout source code repo - compile, SonarQube (static code analysis) - test (travis file)
//        |                                            |----------------->| -------------------------JAR/WAR------------------------>|
//        |                                            |---------------------------|                                                 |
//        |                                                                                                                          |
//     Dockerfile -------------------------------------------------------------------------------------------------------------------|
//
//
//
// Post-Merge Pipeline  with Wrapper in Gerrit and SourceCode in GITHUB:
//   GITHUB_REPO must be defined as inparam to pipeline
// ###################
//        - When Gerrit merge performed (After manual Review "+2", verified "+1"
//          in Pre-Merge pipline). The Post Post-Merge Pipeline will be
//          triggered via Gerrit Event
//        - ALL steps are available for execution (depends on pipeline input
//          params)
//
// Gerrit Review performed and merge submitted
// (GERRIT_EVENT_TYPE: change-merged)
//        |
// Gerrit Event
//        |
//   Wrapper repo                 Source Code repo
//    build_info.yml including -> hash -> checkout source code repo - compile, SonarQube (static code analysis) - test (travis file) - upload ARM - build & push images
//        |                                            |----------------->| -------------------------JAR/WAR-----------------------------> |    |---->|
//        |                                            |---------------------------|                                                                  |
//        |                                                                                                                                           |
//     Dockerfile ------------------------------------------------------------------------------------------------------------------------------------|
//
// #############################################################################
// Pre-Merge Pipeline with Sourcecode in Gerrit:  GITHUB_REPO must NOT not be
// defined as inparam to pipeline
// ##################
//        - Commit for Review will issue Gerrit event which will trigger
//          pipeline (Jenkinsfile) in gerrit repo
//        - Pipeline will identify Pre-merge (patchset for review in Gerrit) and
//          execute build test steps, but no artifact/image uploads
//        - Success will update Gerrit Review Verified with "+1", else "-1".
//          Now Manual Gerrit Code review (+2) is needed.
//
//  Gerrit commit for Review (GERRIT_EVENT_TYPE: patchset-created)
//        |
// Gerrit Event
//        |
//   Gerrit repo (Source Code repo)
//    checkout source code repo - compile, SonarQube (static code analysis) - test (travis file)
//        |        |----------------->| -------------------------JAR/WAR------------------------>|
//        |        |---------------------------|                                                 |
//        |                                                                                      |
//     Dockerfile -------------------------------------------------------------------------------|
//
//
//
// Post-Merge Pipeline  with Wrapper in Gerrit and SourceCode in GITHUB:
// GITHUB_REPO must NOT not be defined as inparam to pipeline
// ###################
//        - When Gerrit merge performed (After manual Review "+2", verified "+1"
//          in Pre-Merge pipeline). The Post Post-Merge Pipeline will be
//          triggered via Gerrit Event
//        - ALL steps are available for execution (depends on pipeline input
//          params)
//
// Gerrit Review performed and merge submitted
// (GERRIT_EVENT_TYPE: change-merged)
//        |
// Gerrit Event
//        |
//   Gerrit repo (Source Code repo)
//     checkout source code repo - compile, SonarQube (static code analysis) - test (travis file) - upload ARM - build & push images
//        |         |----------------->| -------------------------JAR/WAR-----------------------------> |    |---->|
//        |         |---------------------------|                                                                  |
//        |                                                                                                        |
//     Dockerfile -------------------------------------------------------------------------------------------------|
//
// ################################################################################################################################################################################
//
// Required repos:
//     - Gerrit repo with docker file and build info file with source code repo
//       hash to be built, also Jenkinsfile calling this shared pipline is
//       required.
//     - SourceCode repo
//
// Gerrit Repo Dockerfile path and JAR/WAR file
//     - src/main/docker/Dockerfile     Optional: If NO Dockerfile included,
//       Docker Image will NOT be built/pushed (example if a module is only used
//       within the project)
//     - src/main/docker/app.jar or app.war (Will be downloaded via ARM in
//       pipeline! Need to be included in Docker Image via Dockerfile (copied)
//     - build_info.yml in the proj root, stamped with sourcecode repo commit
//       hash to be built (Stamped via github poller)
//
// Required Jenkins Credentials:
//     - GERRIT_CREDENTIALS (Username with password)
//     - SONARQUBE_TOKEN (Secret text)
//     - ARTIFACTORY_CREDENTIALS (Username with password)
//
// InParams:
//   - GITHUB_REPO                   Optional: Required only if sourcecode exist
//                                             in GITHUB and wrapper repo exist
//                                             in Gerrit
//   - GERRIT_GIT_SERVER             Required: Gerrit repo GIT Server
//   - GERRIT_GIT_PROJECT            Required: Gerrit repo Project
//   - BUILD_INFO_FILE               Required: if Gerrit repo is an wrapper for
//                                             SourceCode repo in GITHUB,
//   - BUILD_COMMAND                 Required: Compile cmd in build step
//   - SONARQUBE_HOST_URL            Optional: if empty ("") SonarQube will NOT
//                                             be performed
//   - CX_ARM_URL              Optional: ARM for uploading compiled
//                                             artifact JAR/WAR, if empty ("")
//                                             No ARM upload will be performed
//   - CX_IMAGE_REGISTRY       Optional: if CX_ARM_URL is not set
//   - CX_IMAGE_REGISTRY_PATH  Optional: if CX_IMAGE_REGISTRY is not
//                                             set
//   - DOCKERHUB_IMAGE_REGISTRY      Optional: if empty ("") Dockerhub Image
//                                             build/push will NOT be performed
//   - DOCKERHUB_IMAGE_REPOSITORY    Optional: if DOCKERHUB_IMAGE_REGISTRY is
//                                             not set
//   - REMREM_PUBLISH_GEN_PUB_URL    Required: Eiffel 2.0 Event handling
//   - REMREM_GENERATE_URL           Required: Eiffel 2.0 Event handling
//   - REMREM_PUBLISH_URL            Required: Eiffel 2.0 Event handling
//
//
//
//    EXAMPLE Calling this shared pipeline code:
//
//    Jenkinsfile needs to be stored in gerrit repo's root:
//
//    #!/usr/bin/env groovy
//
//    library identifier: 'myshared@master', retriever: modernSCM([$class: 'GitSCMSource',
//    remote: 'http://gerrit.cx.se/a/eiffel/eiffel2/eiffel-ci-cd-cr/eiffel-pipeline-shared/eiffel-jenkins-pipeline-shared',
//    credentialsId: 'GERRIT_CREDENTIALS',
//    excludes: '',
//    includes: '*',
//    rawRefSpecs: ''
//    ]) _
//
//    Java_K8S_CI_Pipeline_Gerrit_And_Sourcecode_Repos{
//      // Required Docker Images with build capabilities to be used in pipeline
//      // build steps
//      DOCKERIMAGE_CHECKOUT = "xxx/xxxxxxxxxx:yyyyy"
//           .
//           .
//       Add all Required InParams stated above!
//
//    }
//
//
// #############################################################################

import org.jenkinsci.plugins.workflow.steps.FlowInterruptedException
import groovy.json.JsonOutput



def call(body) {

  def pipelineParams= [:]
  body.resolveStrategy = Closure.DELEGATE_FIRST
  body.delegate = pipelineParams
  body()


  // ## Global Vars
  String SOURCECODE_DIR
  String GIT_SHORT_COMMIT
  String GIT_LONG_COMMIT
  String SC_GIT_HASH_TO_USE
  def ARTIFACTLIST = []
  def artCCompileEventIds = []

  String REMREM_PUBLISH_GEN_PUB_URL = "$pipelineParams.REMREM_PUBLISH_GEN_PUB_URL"
  String REMREM_GENERATE_URL = "$pipelineParams.REMREM_GENERATE_URL"
  String REMREM_PUBLISH_URL = "$pipelineParams.REMREM_PUBLISH_URL"


  def label = "ciworker-${UUID.randomUUID().toString()}"

  podTemplate(label: label, containers: [
    containerTemplate(name: 'imagecheckout', image: "$pipelineParams.DOCKERIMAGE_CHECKOUT", command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'imagecompile', image: "$pipelineParams.DOCKERIMAGE_COMPILE", command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'imagecodeanalysis', image: "$pipelineParams.DOCKERIMAGE_CODEANALYSIS", command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'imageunittest', image: "$pipelineParams.DOCKERIMAGE_UNITTEST", command: 'cat', ttyEnabled: true, privileged: true),
    containerTemplate(name: 'imagearmpublish', image: "$pipelineParams.DOCKERIMAGE_ARMPUBLISH", command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'imagedockerbuildpush', image: "$pipelineParams.DOCKERIMAGE_DOCKER_BUILD_PUSH", command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'imageremrem', image: "$pipelineParams.DOCKERIMAGE_REMREM_EVENTS", command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'maven', image: "maven", command: 'cat', ttyEnabled: true)
  ],
  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
    //persistentVolumeClaim( mountPath: '/home/jenkins/.m2/repository', claimName: 'myci-jenkins', readOnly: false)
    //persistentVolumeClaim(mountPath: '/root/.m2/repository', claimName: 'myci-jenkins', readOnly: false)
    //persistentVolumeClaim(mountPath: '/root/.m2/repository', claimName: 'maven-local-repo', readOnly: false)
    // Multi-Attach error for volume....
    //  /home/jenkins/.m2

  ]) {
    node(label) {

      try {

        // Setup some Jenkins job properties. These statements overwrite what is
        // manually defined in the Jenkins job.
        // - Job parameters
        // - Gerrit Trigger properties
        properties([
          parameters([
            string(name: 'GERRIT_BRANCH', defaultValue: 'master'),
            string(name: 'GERRIT_REFSPEC', defaultValue: 'refs/heads/master'),
            string(name: 'GERRIT_CHANGE_NUMBER', defaultValue: ''),
            string(name: 'GERRIT_PATCHSET_NUMBER', defaultValue: ''),
            string(name: 'GERRIT_PATCHSET_REVISION', defaultValue: ''),
            string(name: 'GERRIT_EVENT_TYPE', defaultValue: 'change-merged')
          ]),
          pipelineTriggers([
            [
              $class: 'GerritTrigger',
              // serverName needs to match a Gerrit Trigger 'Server Name' in
              // the Jenkins instance.
              serverName: "$pipelineParams.GERRIT_GIT_SERVER_NP",
              gerritProjects: [
                [
                  $class: "GerritProject",
                  compareType: "PLAIN",
                  pattern: "$pipelineParams.GERRIT_GIT_PROJECT",
                  branches: [
                    [
                      $class: "Branch",
                      compareType: "ANT",
                      pattern: "**"
                    ]
                  ]
                ]
              ],
              silentMode: true,
              triggerOnEvents: [
                [$class: "PluginPatchsetCreatedEvent"],
                [$class: "PluginChangeMergedEvent"]
              ]
            ]
          ])
        ])

        stage ('Gerrit Checkout') {
          container('imagecheckout') {
            dir ('gerrit') {

              sh "git config -l"

              echo sh(returnStdout: true, script: 'env')

              println "GERRIT_BRANCH: ${GERRIT_BRANCH}"
              println "GERRIT_REFSPEC: ${GERRIT_REFSPEC}"
              println "GERRIT_CHANGE_NUMBER: ${GERRIT_CHANGE_NUMBER}"
              println "GERRIT_PATCHSET_NUMBER: ${GERRIT_PATCHSET_NUMBER}"
              println "GERRIT_PATCHSET_REVISION: ${GERRIT_PATCHSET_REVISION}"
              println "GERRIT_EVENT_TYPE: ${GERRIT_EVENT_TYPE}"

              sh "export JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/jre"

              def branchToUse = ""
              if ("${GERRIT_PATCHSET_REVISION}"?.trim()) {
                branchToUse = "${GERRIT_PATCHSET_REVISION}".trim()
              } else {
                branchToUse = "${GERRIT_BRANCH}".trim()
              }

              checkout([
                $class: 'GitSCM',
                branches: [[name: "${branchToUse}"]],
                doGenerateSubmoduleConfigurations: false,
                extensions: [[$class: 'WipeWorkspace']],
                submoduleCfg: [],
                userRemoteConfigs: [[
                  credentialsId: 'GERRIT_CREDENTIALS',
                  refspec: "${GERRIT_REFSPEC}",
                  url: "$pipelineParams.GERRIT_GIT_SERVER/$pipelineParams.GERRIT_GIT_PROJECT"
                ]]
              ])

              sccEventId = sendSCCEvent(REMREM_PUBLISH_GEN_PUB_URL,
                                        REMREM_GENERATE_URL,
                                        REMREM_PUBLISH_URL,"$pipelineParams.GERRIT_GIT_SERVER/$pipelineParams.GERRIT_GIT_PROJECT")

              if ("${pipelineParams.GITHUB_REPO}"?.trim() && "${pipelineParams.BUILD_INFO_FILE}"?.trim()) {
                sh "cat $pipelineParams.BUILD_INFO_FILE"
                def props = readYaml file: "$pipelineParams.BUILD_INFO_FILE"

                SC_GIT_HASH_TO_USE = props.scm.github_commit

                sh "echo hash -> $SC_GIT_HASH_TO_USE"
              } else {  // use pom from Gerrit Repo

                GIT_SHORT_COMMIT = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
                GIT_LONG_COMMIT =  sh(returnStdout: true, script: "git log --format='%H' -n 1").trim()

                sh "echo GIT_LONG_COMMIT: ${GIT_LONG_COMMIT}"
                sh "echo GIT_SHORT_COMMIT: ${GIT_SHORT_COMMIT}"
                sh "ls"

                Object POM = readMavenPom()
                def POMmodules = POM.modules

                if (POMmodules) {
                  POMmodules.each { artifactItem ->
                    sh "echo modules: ${artifactItem}"
                    ARTIFACTLIST.add(POMHandler(artifactItem))
                  }
                } else {
                  ARTIFACTLIST.add(POMHandler("."))
                }

                sh "echo moduleslist: ${ARTIFACTLIST}"

              }

            } // dir
          }
        }


        if ("${pipelineParams.GITHUB_REPO}"?.trim()) {
          SOURCECODE_DIR = "github"
          stage ("GITHUB Checkout: $SC_GIT_HASH_TO_USE") {
            container('imagecheckout') {
              dir ('github') {

                checkout scm: [
                  $class: 'GitSCM',
                  userRemoteConfigs: [[url: "$pipelineParams.GITHUB_REPO"]],
                  branches: [[name: "$SC_GIT_HASH_TO_USE"]],
                  extensions: [[$class: 'WipeWorkspace']]]


                GIT_SHORT_COMMIT = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
                GIT_LONG_COMMIT =  sh(returnStdout: true, script: "git log --format='%H' -n 1").trim()

                sh "echo GIT_LONG_COMMIT: ${GIT_LONG_COMMIT}"
                sh "echo GIT_SHORT_COMMIT: ${GIT_SHORT_COMMIT}"
                sh "ls"

                Object POM = readMavenPom()
                def POMmodules = POM.modules

                if (POMmodules) {
                  POMmodules.each { artifactItem ->
                    sh "echo modules: ${artifactItem}"
                    ARTIFACTLIST.add(POMHandler(artifactItem))
                  }
                } else {
                  ARTIFACTLIST.add(POMHandler("."))
                }

                sh "echo moduleslist: ${ARTIFACTLIST}"
              }
            }
          }
        } else {
          SOURCECODE_DIR = "gerrit"  // if no GITHUB repo defined, use gerrit as sourcecode repo
        }


        stage('Compile') {
          sh "echo Directory: ${SOURCECODE_DIR}"
          container('imagecompile') {
            dir ("${SOURCECODE_DIR}") {

              edCompileEventId =
                sendEDEvent(sccEventId,
                            "CompileEnvironment",
                            "${pipelineParams.DOCKERIMAGE_COMPILE}",
                            REMREM_PUBLISH_GEN_PUB_URL,
                            REMREM_GENERATE_URL,
                            REMREM_PUBLISH_URL)
                cdCompileEventId = sendCDEvent(sccEventId,
                                               "SourceCompileComposition",
                                               REMREM_PUBLISH_GEN_PUB_URL,
                                               REMREM_GENERATE_URL,
                                               REMREM_PUBLISH_URL)

          		sh "${pipelineParams.BUILD_COMMAND}"

                ARTIFACTLIST.each { artifactItem ->

                  def ARTIFACTSPLIT = artifactItem.split(":")

                  sh "echo ${ARTIFACTSPLIT}"

                  artifactGroupId = ARTIFACTSPLIT[1]
                  artifactId = ARTIFACTSPLIT[2]
                  artifactVersion = ARTIFACTSPLIT[3]
                  artifactName = ARTIFACTSPLIT[2]
                  identity="pkg:maven/${artifactGroupId}/${artifactId}@${artifactVersion}"


                  tmpArtCId =
                    sendArtCEvent(edCompileEventId,
                                  cdCompileEventId,
                                  "${pipelineParams.BUILD_COMMAND}",
                                  identity,
                                  artifactName,
                                  REMREM_PUBLISH_GEN_PUB_URL,
                                  REMREM_GENERATE_URL,
                                  REMREM_PUBLISH_URL)
                  artCCompileEventIds.add(tmpArtCId)
                }

              sh "ls"

              stash "${SOURCECODE_DIR}"

            }
          }
        }


        if ("${pipelineParams.SONARQUBE_HOST_URL}"?.trim()) {
          stage('SonarQube Code Analysis') {
            container('imagecodeanalysis') {
              dir ("${SOURCECODE_DIR}") {

                sh "ls"

                withCredentials([string(credentialsId: 'SONARQUBE_TOKEN', variable: 'SonarQubeToken')]) {

                   sh "mvn sonar:sonar -Dsonar.host.url=$pipelineParams.SONARQUBE_HOST_URL -Dsonar.login=$SonarQubeToken"

                }
                edSonarEventId =
                  sendEDEvent(sccEventId,
                              "SonarqubeEnvironment",
                              "${pipelineParams.DOCKERIMAGE_CODEANALYSIS}",
                              REMREM_PUBLISH_GEN_PUB_URL,
                              REMREM_GENERATE_URL,
                              REMREM_PUBLISH_URL)
                  sendCLMEvent(artCCompileEventIds[0],
                               "sonarQube",
                               REMREM_PUBLISH_GEN_PUB_URL,
                               REMREM_GENERATE_URL,
                               REMREM_PUBLISH_URL)
              }
            }
          }
        } //if (


        stage('UnitTests & ComponentTests') {
          container('imageunittest') {
            dir ("${SOURCECODE_DIR}") {

              def test_cmds = []

              def UNIT_TEST_CMDS = pipelineParams.UNIT_TEST_COMMANDS

              if (UNIT_TEST_CMDS.isEmpty()) {
                // Execute tests (steps) in travis file  ie same file which is used in travis build (open source) or UNIT_TEST_COMMANDS if defined
                test_cmds = readYaml file: ".travis.yml"
                sh "echo ${test_cmds}"
                test_cmds.script.each { item ->
                   sh "$item"
                };
              } else {
                // Execute tests (steps) in UNIT_TEST_COMMANDS
                test_cmds = UNIT_TEST_CMDS
                sh "echo ${test_cmds}"
                test_cmds.each { item ->
                   sh "$item"
                };
              }

              sh "ls"

              edUnitEventId =
                sendEDEvent(sccEventId,
                            "UnitTestEnvironment",
                            "${pipelineParams.DOCKERIMAGE_UNITTEST}",
                            REMREM_PUBLISH_GEN_PUB_URL,
                            REMREM_GENERATE_URL,
                            REMREM_PUBLISH_URL)
              sendCLMEvent(artCCompileEventIds[0],
                           "unitFlow",
                           REMREM_PUBLISH_GEN_PUB_URL,
                           REMREM_GENERATE_URL,
                           REMREM_PUBLISH_URL)
            }
          }
        }


        if ("${GERRIT_EVENT_TYPE}"=="change-merged") {

          if ("${pipelineParams.CX_ARM_URL}"?.trim()) {
            stage('Publish Artifact ARM -> WAR/JAR)') {
              container('imagearmpublish') {
                dir ("${SOURCECODE_DIR}_copy") {
                  unstash "${SOURCECODE_DIR}"

                  withCredentials([[
                    $class: 'UsernamePasswordMultiBinding',
                    credentialsId: 'ARTIFACTORY_CREDENTIALS',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASSWORD']]) {

                    ARTIFACTLIST.eachWithIndex { artifactItem, index ->

                      def ARTIFACTSPLIT = artifactItem.split(":")

                      sh "echo modules: ${artifactItem}"

                      def ARM_ARTIFACT = artifactBuilder(ARTIFACTSPLIT)

                      def ARM_ARTIFACT_PATH = artifactPathBuilder(artifactItem, pipelineParams.CX_ARM_URL)

                      sh "echo ${ARM_ARTIFACT_PATH}"

                      sh "ls"

                      def target_path = ""
                      if ("${ARTIFACTSPLIT[0]}" != ".") {
                        target_path = "./${ARTIFACTSPLIT[0]}/target/${ARM_ARTIFACT}"
                      } else {
                        target_path = "./target/${ARM_ARTIFACT}"
                      }

                      doCurl("-u ${USER}:${PASSWORD} --upload-file ${target_path} ${ARM_ARTIFACT_PATH}", "201")

                      sh "echo About to send ArtP event"

                      sh "echo artifactItem: ${artifactItem}"
                      sh "echo index: ${index}"

                      sendArtPEvent(artCCompileEventIds[index],
                                    "ARTIFACTORY",
                                    "${ARM_ARTIFACT_PATH}",
                                    REMREM_PUBLISH_GEN_PUB_URL,
                                    REMREM_GENERATE_URL,
                                    REMREM_PUBLISH_URL)

                    } // eachWithIndex
                  } // withCredentials
                } //dir
              }
            }
          } //if (


          if ("${pipelineParams.CX_IMAGE_REGISTRY}"?.trim()) {
            stage('Build and Push Docker Image to Registry') {
              container('imagedockerbuildpush') {
                dir ('gerrit') {

                  ARTIFACTLIST.eachWithIndex { artifactItem, index ->

                    def ARTIFACTSPLIT = artifactItem.split(":")

                    def ARM_ARTIFACT_PATH = artifactPathBuilder(artifactItem, pipelineParams.CX_ARM_URL)

                    def app_n_dockerfile_path = ""
                    if ("${ARTIFACTSPLIT[0]}" != ".") {
                      app_n_dockerfile_path = "${ARTIFACTSPLIT[0]}/src/main/docker"
                    } else {
                      app_n_dockerfile_path = "src/main/docker"
                    }

                    def dockerfile_exist = fileExists "${app_n_dockerfile_path}/Dockerfile"
                    if (!dockerfile_exist) { return }  // check if Dockerfile exist ..else return  -> eachWithIndex


                    edImageBuildEventId =
                      sendEDEvent("${artCCompileEventIds[index]}",
                                  "ImageBuildEnvironment",
                                  "${pipelineParams.DOCKERIMAGE_DOCKER_BUILD_PUSH}",
                                  REMREM_PUBLISH_GEN_PUB_URL,
                                  REMREM_GENERATE_URL,
                                  REMREM_PUBLISH_URL)
                    cdImageBuildEventId = sendCDEvent(artCCompileEventIds[index],
                                                      "ImageBuildComposition",
                                                      REMREM_PUBLISH_GEN_PUB_URL,
                                                      REMREM_GENERATE_URL,
                                                      REMREM_PUBLISH_URL)


                    sh "echo ${ARM_ARTIFACT_PATH}"
                    sh "ls ${app_n_dockerfile_path}"

                    def exists = fileExists "${app_n_dockerfile_path}/app.jar"
                    if (exists) {
                      sh "rm ${app_n_dockerfile_path}/app.jar"
                    }

                    exists = fileExists "${app_n_dockerfile_path}/app.war"
                    if (exists) {
                      sh "rm ${app_n_dockerfile_path}/app.war"
                    }

                    sh "ls ${app_n_dockerfile_path}"

                    withCredentials([[$class: 'UsernamePasswordMultiBinding',
                                      credentialsId: 'ARTIFACTORY_CREDENTIALS',
                                      usernameVariable: 'USER',
                                      passwordVariable: 'PASSWORD']]) {

                      // Fetch Artifact (jar/war) from ARM
                      doCurl("-X GET -u ${USER}:${PASSWORD} ${ARM_ARTIFACT_PATH} -o ${app_n_dockerfile_path}/app.${ARTIFACTSPLIT[4]}", "200")

                      sh "ls ${app_n_dockerfile_path}"

                    }

             

                    
                    if ("${pipelineParams.CX_IMAGE_REGISTRY}"?.trim()) {
                      withCredentials([[$class: 'UsernamePasswordMultiBinding',
                                        credentialsId: 'IMAGE_REGISTRY_CREDENTIALS',
                                        usernameVariable: 'USER',
                                        passwordVariable: 'PASSWORD']]) {

                        def BRANCH_TAG = ""

                        def IMG_REG_PATH = "${pipelineParams.CX_IMAGE_REGISTRY}/${pipelineParams.CX_IMAGE_REPOSITORY}"
                        def IMG_TAG_LATEST = "${IMG_REG_PATH}/${ARTIFACTSPLIT[2]}:latest"
                       
                        sh "docker login ${pipelineParams.CX_IMAGE_REGISTRY} -u ${USER} -p ${PASSWORD}"
           
                        if ("${GERRIT_EVENT_TYPE}"=="patchset-created") {                          
                          BRANCH_TAG="refs-changes"
                        }else{
                          BRANCH_TAG="${GERRIT_BRANCH}"
                        }

                        def IMG_TAG_VERSION = "${IMG_REG_PATH}/${ARTIFACTSPLIT[2]}:${ARTIFACTSPLIT[3]}-${BRANCH_TAG}-${GIT_SHORT_COMMIT}"

                        sh "docker build --no-cache=true -t ${IMG_TAG_VERSION} -f ${app_n_dockerfile_path}/Dockerfile ${app_n_dockerfile_path}"

                        sh "docker push ${IMG_TAG_VERSION}"

                        if ("${GERRIT_EVENT_TYPE}"=="change-merged") {     

                          sh "docker tag ${IMG_TAG_VERSION} ${IMG_TAG_LATEST}"

                          sh "docker push ${IMG_TAG_LATEST}"

                          sh "docker rmi ${IMG_TAG_LATEST}"
                        
                        }

                        sh "docker rmi ${IMG_TAG_VERSION}"

                        sh "docker logout ${pipelineParams.CX_IMAGE_REGISTRY}"


                        artifactGroupId="${ARTIFACTSPLIT[1]}"
                        artifactId="${ARTIFACTSPLIT[2]}"
                        artifactVersion="${IMG_TAG_VERSION}"
                        artifactName="${ARTIFACTSPLIT[2]}"
                        identity="pkg:docker/${IMG_REG_PATH}@${IMG_TAG_VERSION}"
                        artCImageBuildEventId =
                          sendArtCEvent(edImageBuildEventId,
                                        cdImageBuildEventId,
                                        "docker build --no-cache=true -t ${IMG_TAG_VERSION} -f ${app_n_dockerfile_path}/Dockerfile ${app_n_dockerfile_path}",
                                        "${identity}",
                                        "${artifactName}",
                                        REMREM_PUBLISH_GEN_PUB_URL,
                                        REMREM_GENERATE_URL,
                                        REMREM_PUBLISH_URL)
                        sendArtPEvent(artCImageBuildEventId,
                                      "OTHER",
                                      "${pipelineParams.CX_IMAGE_REGISTRY}/${pipelineParams.CX_IMAGE_REPOSITORY}/${artifactId}",
                                      REMREM_PUBLISH_GEN_PUB_URL,
                                      REMREM_GENERATE_URL,
                                      REMREM_PUBLISH_URL)



                        // Run Docker Image Tests here



                        sendCLMEvent(artCImageBuildEventId,
                                    "readyForSystemIntegration",
                                    REMREM_PUBLISH_GEN_PUB_URL,
                                    REMREM_GENERATE_URL,
                                    REMREM_PUBLISH_URL)                                      

                      } // withCredentials(
                    } // if (


                  } // ARTIFACTLIST.eachWithIndex
                }  //dir ('gerrit')
              } // container(..
            } // stage(
          } //if (

        } // if("${GERRIT_EVENT_TYPE}"=="change-merged")


        if ("${GERRIT_EVENT_TYPE}"=="patchset-created") {
          if ("${GERRIT_CHANGE_NUMBER}"?.trim() && "${GERRIT_PATCHSET_NUMBER}"?.trim()) {
            stage('Gerrit Code-Review Verified +1') {
              def gerrit_message = "CI Test Passed. Verified by: ${env.BUILD_URL}"
              updateGerritCodeReviewVerified("${pipelineParams.GERRIT_GIT_SERVER}", "${GERRIT_CHANGE_NUMBER}", "${GERRIT_PATCHSET_NUMBER}", "${gerrit_message}", "+1")
            }
          }
        }

        currentBuild.result = 'SUCCESS'

      } catch (FlowInterruptedException interruptEx) {

        echo "ABORTED"

        currentBuild.result = 'ABORTED'

        // Throw
        throw interruptEx

      } catch (err) {
        if ("${GERRIT_EVENT_TYPE}"=="patchset-created") {
          if ("${GERRIT_CHANGE_NUMBER}"?.trim() && "${GERRIT_PATCHSET_NUMBER}"?.trim()) {
            stage('Gerrit Code-Review Verified -1') {
              def gerrit_message = "CI Test Failed. Verified by: ${env.BUILD_URL}"
              updateGerritCodeReviewVerified("${pipelineParams.GERRIT_GIT_SERVER}", "${GERRIT_CHANGE_NUMBER}", "${GERRIT_PATCHSET_NUMBER}", "${gerrit_message}", "-1")
            }
          }
        }

        echo "FAILURE: ${err}"

        currentBuild.result = 'FAILURE'

      } finally {
        stage('Node Clean Up') {
          step([$class: 'WsCleanup'])
        }
      } // finally
    } // node
  } // podTemplate

  echo "RESULT: ${currentBuild.result}"
} // def call(body)



def updateGerritCodeReviewVerified(gerritServer, gerritChangeNo,
                                   gerritPatchSetNo, gerritMessage, verified) {
  container('imagedockerbuildpush') {
    withCredentials([[$class: 'UsernamePasswordMultiBinding',
                      credentialsId: 'GERRIT_CREDENTIALS',
                      usernameVariable: 'USER',
                      passwordVariable: 'PASSWORD']]) {

       doCurl("-X POST -d '{\"reviewer\":\"${USER}\",\"message\":\"${gerritMessage}\",\"labels\":{\"Verified\":\"${verified}\"}}' -H \"Content-Type: application/json\" --user \"${USER}:${PASSWORD}\" ${gerritServer}/a/changes/${gerritChangeNo}/revisions/${gerritPatchSetNo}/review", "200")


    }
  }
}


def POMHandler(self) {

  def POMgroupId = sh(script: "mvn -N -f ${self}/pom.xml org.apache.maven.plugins:maven-help-plugin:3.1.0:evaluate -Dexpression=project.groupId -q -DforceStdout", returnStdout: true).toString().trim()
  def POMartifactId = sh(script: "mvn -N -f ${self}/pom.xml org.apache.maven.plugins:maven-help-plugin:3.1.0:evaluate -Dexpression=project.artifactId -q -DforceStdout", returnStdout: true).toString().trim()
  def POMversion = sh(script: "mvn -N -f ${self}/pom.xml org.apache.maven.plugins:maven-help-plugin:3.1.0:evaluate -Dexpression=project.version -q -DforceStdout", returnStdout: true).toString().trim()
  def POMpackaging = sh(script: "mvn -N -f ${self}/pom.xml org.apache.maven.plugins:maven-help-plugin:3.1.0:evaluate -Dexpression=project.packaging -q -DforceStdout", returnStdout: true).toString().trim()

  return "${self}:${POMgroupId}:${POMartifactId}:${POMversion}:${POMpackaging}"
}


def artifactPathBuilder(self, CX_ARM_URL) {
  def ARTIFACTSPLIT = self.split(":")
  def version = ""

  def ARM_GROUPID_PATH = "${ARTIFACTSPLIT[1]}".replace(".", "/")     // convert groupId to path

  def ARM_ARTIFACT = artifactBuilder(ARTIFACTSPLIT)

  if("${ARTIFACTSPLIT[3]}".contains("-SNAPSHOT"))
  {
    version="${ARTIFACTSPLIT[3]}"
  }else{
    version="${ARTIFACTSPLIT[3]}-SNAPSHOT"
  }

  return "${CX_ARM_URL}/${ARM_GROUPID_PATH}/${ARTIFACTSPLIT[2]}/${version}/${ARM_ARTIFACT}"
  //return "${CX_ARM_URL}/${ARM_GROUPID_PATH}/${ARTIFACTSPLIT[2]}/${ARTIFACTSPLIT[3]}/${ARM_ARTIFACT}"
}


def artifactBuilder(ARTIFACTSPLIT) {
  return "${ARTIFACTSPLIT[2]}-${ARTIFACTSPLIT[3]}.${ARTIFACTSPLIT[4]}"
}



String sendEDEvent(causeEventId, environmentName, dockerImage,
                   remremGenerateAndPublishUri, remremGenerateUri,
                   remremPublishUri) {
  // Define/collect data for the event message

  String sourceDomain = "to.be.set"
  String sourceHost = env.HOSTNAME ?:
    sh(returnStdout: true, script: "hostname").trim()
  String sourceName = "Jenkins"
  String sourceUri = env.BUILD_URL ?: "unknown"

  Map event_data = [
    "msgParams": [
      "meta": [
        "source": [
          "domainId": sourceDomain,
          "host": sourceHost,
          "name": sourceName,
          "uri": sourceUri
        ]
      ]
    ],
    "eventParams": [
      "data": [
        "name": "${environmentName}",
        "image": "${dockerImage}"
      ],
      "links": [
        [
          "type": "CAUSE",
          "target": "${causeEventId}"
        ]
      ]
    ]
  ]

  return sendEvent("EiffelEnvironmentDefinedEvent",
                   event_data,
                   remremGenerateAndPublishUri,
                   remremGenerateUri,
                   remremPublishUri)
}


String sendCDEvent(causeEventId, compositionName, remremGenerateAndPublishUri,
                   remremGenerateUri, remremPublishUri) {
    // Define/collect data for the event message

  String sourceDomain = "to.be.set"
  String sourceHost = env.HOSTNAME ?:
    sh(returnStdout: true, script: "hostname").trim()
  String sourceName = "Jenkins"
  String sourceUri = env.BUILD_URL ?: "unknown"

  Map event_data = [
    "msgParams": [
      "meta": [
        "source": [
          "domainId": sourceDomain,
          "host": sourceHost,
          "name": sourceName,
          "uri": sourceUri
        ]
      ]
    ],
    "eventParams": [
      "data": [
        "name": "${compositionName}",
      ],
      "links": [
        [
          "type": "CAUSE",
          "target": "${causeEventId}"
        ]
      ]
    ]
  ]

  return sendEvent("EiffelCompositionDefinedEvent",
                   event_data,
                   remremGenerateAndPublishUri,
                   remremGenerateUri,
                   remremPublishUri)
}


String sendCLMEvent(artCEventId, clName, remremGenerateAndPublishUri,
                    remremGenerateUri, remremPublishUri) {
  // Define/collect data for the event message

  String sourceDomain = "to.be.set"
  String sourceHost = env.HOSTNAME ?:
    sh(returnStdout: true, script: "hostname").trim()
  String sourceName = "Jenkins"
  String sourceUri = env.BUILD_URL ?: "unknown"

  Map event_data = [
    "msgParams": [
      "meta": [
        "source": [
          "domainId": sourceDomain,
          "host": sourceHost,
          "name": sourceName,
          "uri": sourceUri
        ]
      ]
    ],
    "eventParams": [
      "data": [
        "name": "${clName}",
        "value": "SUCCESS",
      ],
      "links": [
        [
          "type": "SUBJECT",
          "target": "${artCEventId}"
        ],
      ]
    ]
  ]

  return sendEvent("EiffelConfidenceLevelModifiedEvent",
                   event_data,
                   remremGenerateAndPublishUri,
                   remremGenerateUri,
                   remremPublishUri)
}


String sendArtCEvent(edEventId, cdEventId, buildCommand,
                     identity, artifactName,
                     remremGenerateAndPublishUri, remremGenerateUri,
                     remremPublishUri) {
  // Define/collect data for the event message

  String sourceDomain = "to.be.set"
  String sourceHost = env.HOSTNAME ?:
    sh(returnStdout: true, script: "hostname").trim()
  String sourceName = "Jenkins"
  String sourceUri = env.BUILD_URL ?: "unknown"

  Map event_data = [
    "msgParams": [
      "meta": [
        "source": [
          "domainId": sourceDomain,
          "host": sourceHost,
          "name": sourceName,
          "uri": sourceUri
        ]
      ]
    ],
    "eventParams": [
      "data": [
        "identity": "${identity}",
        "buildCommand": "${buildCommand}",
        "name": "${artifactName}",
      ],
      "links": [
        [
          "type": "ENVIRONMENT",
          "target": "${edEventId}"
        ],
        [
          "type": "COMPOSITION",
          "target": "${cdEventId}"
        ]
      ]
    ]
  ]

  return sendEvent("EiffelArtifactCreatedEvent",
                   event_data,
                   remremGenerateAndPublishUri,
                   remremGenerateUri,
                   remremPublishUri)
}


String sendArtPEvent(artCEventId, locationType, locationUri,
                     remremGenerateAndPublishUri, remremGenerateUri,
                     remremPublishUri) {
  // Define/collect data for the event message

  String sourceDomain = "to.be.set"
  String sourceHost = env.HOSTNAME ?:
    sh(returnStdout: true, script: "hostname").trim()
  String sourceName = "Jenkins"
  String sourceUri = env.BUILD_URL ?: "unknown"

  Map event_data = [
    "msgParams": [
      "meta": [
        "source": [
          "domainId": sourceDomain,
          "host": sourceHost,
          "name": sourceName,
          "uri": sourceUri
        ]
      ]
    ],
    "eventParams": [
      "data": [
        "locations": [
          [
            "type": "${locationType}",
            "uri": "${locationUri}"
          ]
        ],
      ],
      "links": [
        [
          "type": "ARTIFACT",
          "target": "${artCEventId}"
        ],
     ]
    ]
  ]

  return sendEvent("EiffelArtifactPublishedEvent",
                   event_data,
                   remremGenerateAndPublishUri,
                   remremGenerateUri,
                   remremPublishUri)
}


String sendSCCEvent(remremGenerateAndPublishUri, remremGenerateUri,
                    remremPublishUri, gerritURI) {
  String sourceDomain = "to.be.set"
  String sourceHost = env.HOSTNAME ?:
    sh(returnStdout: true, script: "hostname").trim()
  String sourceName = "to.be.set"
  String sourceUri = env.BUILD_URL ?: "unknown"

  String authorName = env.GERRIT_CHANGE_OWNER_NAME ?:
    sh(returnStdout: true,
       script: "git --no-pager show -s --format='%cn' -n 1").trim()
  String authorEmail = env.GERRIT_CHANGE_OWNER_EMAIL ?:
    sh(returnStdout: true,
       script: "git --no-pager show -s --format='%ae' -n 1").trim()
  String authorId = "to.be.set"

  String commitId = env.GERRIT_PATCHSET_REVISION ?:
    sh(returnStdout: true, script: "git log --format='%H' -n 1").trim()
  String repoUri = "${gerritURI}"
  String branch = env.GERRIT_BRANCH ?: "unknwon"
  String repoName = env.GERRIT_PROJECT ?: "unknown"
  String commitMessage = env.GERRIT_CHANGE_SUBJECT ?:
    sh(returnStdout: true,
       script: "git --no-pager show -s --format='%s' -n 1").trim()

  int changeInsertions =
    sh(returnStdout: true,
       script: "git log --shortstat -n 1 | egrep 'file changed|files changed' | awk '{inserted+=\$4;} END {print inserted}'").trim()
  int changeDeletions =
    sh(returnStdout: true,
       script: "git log --shortstat -n 1 | egrep 'file changed|files changed' | awk '{deleted+=\$6;} END {print deleted}'").trim()
  String revision = "1"  // TODO: This needs to be looked up somehow (patchset number)!
  String changeFilesUri = "https://gerrit.CX.se/a/changes/${commitId}/revisions/${revision}/files"
  String changeTracker = "Gerrit"
  String changeDetails = env.GERRIT_CHANGE_URL ?: "unknown"
  String changeId = env.GERRIT_REFSPEC ?: "unknown"

  Map event_data = [
    "msgParams": [
      "meta": [
        "source": [
          "domainId": sourceDomain,
          "host": sourceHost,
          "name": sourceName,
          "uri": sourceUri
        ]
      ]
    ],
    "eventParams": [
      "data": [
        "author": [
          "name": authorName,
          "email": authorEmail,
          "id": authorId,
        ],
        "change": [
          "insertions": changeInsertions,
          "deletions": changeDeletions,
          "files": changeFilesUri,
          "tracker": changeTracker,
          "details": changeDetails,
          "id": changeId
        ],
        "gitIdentifier": [
          "commitId": commitId,
          "repoUri": repoUri,
          "branch": branch,
          "repoName": repoName
        ],
        "customData": [],
// Comment out Commit Message since it is not part of the protocol. If we really
// need it it should be added as an optional field in the "change" object in
// protocol instead.
//                    [
//                        "key" : "Commit Message",
//                        "value" : commitMessage
//                    ]
//                ],
        "issues": []
      ],
      "links": []
    ]
  ]

  return sendEvent("EiffelSourceChangeCreatedEvent", event_data,
                   remremGenerateAndPublishUri, remremGenerateUri,
                   remremPublishUri)
}
