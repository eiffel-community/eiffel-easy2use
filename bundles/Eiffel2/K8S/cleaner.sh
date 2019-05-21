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
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_RABBITMQ"-0
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_DUMMY_ER"-0
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_ER"-0
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_JENKINS_FEM"-0
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_JENKINS"-0
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_NEXUS3_PROXY"-0
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_NEXUS3_CONFIG"-0
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_NEXUS3"-0
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_REMREM_GENERATE"-0
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_REMREM_PUBLISH"-0
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_VICI"-0
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_VE"-0
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_EI_FRONTEND"-0
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_EI_BACKEND_ALLEVENTS"-0
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_EI_BACKEND_ARTIFACT"-0
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_EI_BACKEND_SOURCECHANGE"-0
kubectl delete pod --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_EI_BACKEND_TESTEXECUTION"-0


kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_RABBITMQ"
kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_DUMMY_ER"
kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_ER"
kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_JENKINS_FEM"
kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_JENKINS"
kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_NEXUS3_PROXY"
kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_NEXUS3"
kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_NEXUS3_CONFIG"
kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_REMREM_GENERATE"
kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_REMREM_PUBLISH"
kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_VICI"
kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_VE"
kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_EI_FRONTEND"
kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_EI_BACKEND_ALLEVENTS"
kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_EI_BACKEND_ARTIFACT"
kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_EI_BACKEND_SOURCECHANGE"
kubectl delete statefulset --grace-period=0 --force --namespace "$K8S_NAMESPACE" "$K8S_RELEASE_EIFFEL2_EI_BACKEND_TESTEXECUTION"
