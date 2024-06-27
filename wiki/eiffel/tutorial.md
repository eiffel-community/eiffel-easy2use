<!---
   Copyright 2024 Ericsson AB.
   For a full list of individual contributors, please see the commit history.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->
# Tutorial for Eiffel Bundle

In the following tutorial, you will go through:

1. Deploy Eiffel bundle using Docker.
1. Check the existing subscriptions.
1. Publish an Eiffel event which triggers a few Jenkins jobs.

## Prerequisites

1. You have installed and you have set up **Docker**.
1. You have cloned [eiffel-easy2use](https://github.com/eiffel-community/eiffel-easy2use.git) repository locally.

**_NOTE:_** Eiffel bundle requires **12GB** RAM usage, approximately.

## Start Eiffel Bundle Using Docker

1. Change directory to *eiffel-easy2use*, for example:
   ```console
   cd eiffel-easy2use
   ```

1. Start Eiffel by executing the command:
   ```console
   ./easy2use start Eiffel -t Docker -e bundles/ -y
   ```

1. Wait until all Docker containers are up and running.
   Check it by executing the command:
   ```console
   docker ps
   ```

## Get the Existing Subscriptions from EI

There are two ways that you can check the existing subscriptions:

1. Execute the following **curl** command:
   ```console
   curl -X GET -H "Content-type: application/json" "http://localhost:8077/subscriptions"
   ```

1. Navigate to **localhost:8077** on your browser and check the subscriptions in the GUI.

## Publish an Eiffel ArtC Event and Trigger the Jenkins Jobs

There are two ways that you can publish an Eiffel event:

1. Execute the following **curl** command:
   ```console
   curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
       "meta": {
            "type": "EiffelArtifactCreatedEvent",
            "version": "3.0.0",
            "time": 1234567890,
            "id": "77a7f4e7-9847-44a6-9bf0-3a19a9528ccd",
            "source": {
                "serializer": "pkg:maven/com.mycompany.tools/eiffel-serializer%401.0.3"
            }
       },
       "data": {
            "identity": "pkg:maven/com.othercompany.library/required@required"
       }
    }' "http://localhost:8096/producer/msg?mp=eiffelsemantics"
   ```

1. Navigate to **localhost:8096** on your browser and publish an 
   Eiffel event via the *Swagger* interface.

Then,

1. Navigate to *Jenkins* or *Jenkins FEM* GUI, **localhost:8051** or **localhost:8052** correspondingly
   and check that some jobs have **SUCESS** status.

1. Navigate to **localhost:8084** on your browswer and press the link *"List all events in ER (result will be paginated)"*
   to view all the Eiffel events that have been created.

## Next Steps

After you have finished the tutorial successfuly, you can experiment with the Eiffel.

For example, you can add a new subscription and publish the corresponding Eiffel event
that triggers an existing Jenkins job or a new Jenkins job.

## Troubleshooting

1. Limited RAM space can restart frequently a Docker container due to memory allocation error.
   In this case, check the RAM usage by executing the command:

   ```console
   free -h
   ```

1. Check the Docker container logs by executing the command:

   ```console
   docker logs <container_id>
   ```

   If there is an error, you can try to restart the container:

   ```console
   docker restart <container_id>
   ```
