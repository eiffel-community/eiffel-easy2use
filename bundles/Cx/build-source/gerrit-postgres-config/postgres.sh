#!/bin/bash
#
#   Copyright 2019 Ericsson AB.
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
psql postgresql://${CX_POSTGRES_USER}:${CX_POSTGRES_PSW}@${POSTGRES_URL}/${CX_POSTGRES_REVIEWDB} << EOF
INSERT INTO public.account_external_ids(account_id, email_address, external_id) VALUES (1000000, '${CI_INIT_EMAIL}', 'keycloak-oauth:${CI_INIT_ADMIN}');
INSERT INTO public.account_external_ids(account_id, password, external_id) VALUES (1000000, 'bcrypt:4:WRKPRNiozSWe4RQncbg1nA==:tMnDIsGm5we9H4bmnu0Yap9J72ztyOM4', 'username:${CI_INIT_ADMIN}');
INSERT INTO public.account_group_members(account_id, group_id) VALUES (1000000, 1);
INSERT INTO public.account_group_members_audit(added_by, account_id, group_id, added_on) VALUES (1000000, 1000000, 1, '2019-01-10 12:00:00.001+00');
INSERT INTO public.accounts(registered_on, full_name, preferred_email, inactive, account_id) VALUES ('2019-01-10 12:00:00.001+00', 'Easy Use', 'admin@example.com', 'N', 1000000);
EOF