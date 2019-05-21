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
// Main function, will be called from other Groovy script 'implicitly'
//
// Requirements:
//   An imaged defined as 'imageremrem' must exist in the caller
//
// Parameters:
//   remremGenerateAndPublishUri: String on the following form:
//        'http://eiffel-remrem-publish-eiffel2.eiffel2:8096/generateAndPublish?mp=eiffelsemantics&parseData=false&msgType='
//
//   remremGenerateUri: String on the following form:
//        'http://eiffel-remrem-generate-eiffel2.eiffel2:8095/eiffelsemantics?msgType='
//
//   remremPublishUri: String on the following form:
//        'http://eiffel-remrem-publish-eiffel2.eiffel2:8096/producer/msg?mp=eiffelsemantics'
//
// #############################################################################
def call(String type, Map data, String remremGenerateAndPublishUri,
         String remremGenerateUri, String remremPublishUri) {
    // Initialize eventId parameter
    String eventId = ''

    container('imageremrem') {
        String jsonData = JsonOutput.toJson(data)
        println "Data to send:" + JsonOutput.prettyPrint(jsonData)

        // Send event using remrem generateAndPublish entry point
        String command = "curl --header 'Content-Type: application/json' -X POST --data-binary '${jsonData}' '${remremGenerateAndPublishUri}${type}'"
        String responseSend = sh(returnStdout: true, script: command)
        println "Send response:" + JsonOutput.prettyPrint(responseSend)

        Map responseSendMap = readJSON text: "${responseSend}"
        println "About to check status_code"
        if (responseSendMap.events[0].status_code == 200) {
            eventId = responseSendMap.events[0].id
        } else {
            println "Send returned some error, trying two-phase event sending"
            // Something went wrong. Try generating the message using remrem
            // generate to possibly get a better error message or to send using
            // the double calls.

            // Generate event using remrem generate
            String commandGenerate = "curl --header 'Content-Type: application/json' -X POST --data-binary '${jsonData}' '${remremGenerateUri}${type}'"
            String responseGenerate =
                sh(returnStdout: true, script: commandGenerate)
            println "Generate response:" + JsonOutput.prettyPrint(responseGenerate)
            Map responseGenerateMap = readJSON text: "${responseGenerate}"
            if(responseGenerateMap[0].status_code!="200"){throw interruptEx}

            // Send generated event using remrem publish
            String commandPublish = "curl --header 'Content-Type: application/json' -X POST --data-binary '${responseGenerate}' '${remremPublishUri}'"
            String responsePublish =
                sh(returnStdout: true, script: commandPublish)
            println "Publish response:" + JsonOutput.prettyPrint(responsePublish)

            Map responsePublishMap = readJSON text: "${responsePublish}"
            if(responsePublishMap[0].status_code!="200"){throw interruptEx}
            eventId = responsePublishMap.events[0].id
        }

        println "Sent event id: ${eventId}"

        // Just for fun :) Look at sent event: curl http://eiffel-er:8080/events/<eventid>
        /*String getEventCommand =
           "curl http://eiffel-er-eiffel2.eiffel2:8084/events/${eventId}"
        String responseGetEvent =
            sh(returnStdout: true, script: getEventCommand)
        println "Get event response:" + JsonOutput.prettyPrint(responseGetEvent)*/

  
    }
    println "Event id to return: ${eventId}"
    return eventId
}
