<!---
   Copyright 2020 Ericsson AB.
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
# Components Included in GitLab Bundle

Component | Service name | User/PSW | Ingress | Info
------------- | ------------ | -------- | ------- | ------------
GitLab | gitlab_gitlab | NA | gitlab-\<domainname\> | user account needs to be created after startup
<b>Services Loaded from Eiffel Bundle*</b> | | |
RabbitMQ (Message Bus) | rabbitmq | myuser / myuser | eiffel-rabbitmq-\<namespace\>.\<domainname\>
MongoDB & Data Seeding | mongodb<br> mongo_seed | N/A | N/A | The seed-data folder in Easy2Use contains data that can be seeded into the MongoDB instance.
RemRem Generate | remrem_generate | N/A | eiffel-remrem-generate-\<namespace\>.\<domainname\>
RemRem Publish | remrem_publish | N/A | eiffel-remrem-publish-\<namespace\>.\<domainname\>
Nexus3 | nexus | admin/admin123 | eiffel-nexus3-\<namespace\>.\<domainname\>
Event Repository REST API | er | N/A | eiffel-er-\<namespace\>.\<domainname\>
Eiffel ViCi | vici | N/A | eiffel-vici-\<namespace\>.\<domainname\>

## Layout
This is a schematic picture of the environment:

<img src="../images/gitlab-components.png" alt="GitLab Easy2Use" width="750"/>

## Principles
<img src="../images/cx-pipelineascode-principles.png" alt="Eiffel Easy2Use Cx pipeline as code principles" width="750"/>
<br><br>
<img src="../images/gitlab-pipeline-events.png" alt="Eiffel Easy2Use gitLab Eiffel Events Generated in CI pipelines" width="750">
