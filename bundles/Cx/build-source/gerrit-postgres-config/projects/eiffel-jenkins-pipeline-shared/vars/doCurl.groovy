import org.jenkinsci.plugins.workflow.steps.FlowInterruptedException
import groovy.json.JsonOutput
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
// #############################################################################
//
// doCurl.groovy
//
// Author: michael.frick@ericsson.com
//
// #############################################################################
def call(String paramsIN, String successCodeExpected) {

    container('imageremrem') {
           //def curlcmd = "curl -s -o /dev/null -w \"%{http_code}\" ${paramsIN}"

           def curlcmd = ""
           
           if ("${paramsIN}".contains("POST") || "${paramsIN}".contains("--upload-file")) {
             curlcmd = "curl -s -o /dev/null -w \"%{http_code}\" ${paramsIN}"
           }
           else if ("${paramsIN}".contains("GET")) {
             curlcmd = "curl -s -w \"%{http_code}\" ${paramsIN}"
           }
           else
           {
               throw interruptEx
           }

             
           println "curlcmd : ${curlcmd}"
           println "successCodeExpected : ${successCodeExpected}"

           String curlResponse = sh(returnStdout: true, script: curlcmd)
           println "CURL response:" + curlResponse

           if(curlResponse!=successCodeExpected){ throw interruptEx }


    }
}
