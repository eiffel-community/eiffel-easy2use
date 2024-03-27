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
echo -e "\n--------------------"
echo    "GET EI Subscriptions"
echo -e "--------------------\n"
curl -X GET -H "Content-type: application/json" "http://eiffel-frontend-${EIFFEL_NAMESPACE}.${EIFFEL_DOMAIN}:80/subscriptions"
