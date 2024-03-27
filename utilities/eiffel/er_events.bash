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

# Get the flags
while getopts ":d:n:l:" opt; do
    case $opt in
      d)
         EIFFEL_DOMAIN="$OPTARG"
         ;;
      n)
         EIFFEL_NAMESPACE="$OPTARG"
         ;;
      l)
         LIMIT="$OPTARG"
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
curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d 'db.events.find({})' \
     "http://eiffel-er-${EIFFEL_NAMESPACE}.${EIFFEL_DOMAIN}:80/datastore/query?pageNo=1&pageSize=${LIMIT}&pageStartTime=1"
