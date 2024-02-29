#
#   Copyright 2024 Ericsson AB.
#   For a full list of individual contributors, please see the commit history.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

# Get the flag values
echo -e "----------------------"
echo    "Configuration settings"
echo -e "----------------------\n"
while getopts ":d:n:" opt; do
    case $opt in
      d)
         echo "Eiffel domain: $OPTARG" >&2
         EIFFEL_DOMAIN="$OPTARG"
         ;;
      n)
         echo "Namespace: $OPTARG" >&2
         EIFFEL_NAMESPACE="$OPTARG"
         ;;
      \?)
          echo "Invalid flag: -$OPTARG" >&2
          exit 1
          ;;
      :)  echo "Flag -$OPTARG requires an argument." >&2
          exit 1
          ;;
    esac
done

# cURL request
echo -e "\n-----------------"
echo    "POST Eiffel ArtC Event"
echo -e "-----------------\n"
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
 }' "http://eiffel-remrem-publish-${EIFFEL_NAMESPACE}.${EIFFEL_DOMAIN}:80/producer/msg?mp=eiffelsemantics"
