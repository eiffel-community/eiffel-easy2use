<!---
   Copyright 2019 Ericsson AB.
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
# Getting Started

This section will give you the general description on how to get started running any of the provided bundles in Easy2Use.

# Prerequisites

To be able to run Easy2Use, make sure you have decided on a [**hosting environment**](./Hosting_Environments.md) and installed and/or set up client access for Docker/Minikube/etc accordingly.

# Quick Getting Started Guide

## Easy2Use Cheatsheet
<a href="../docs/Easy2Use_CheatSheet.pdf" target="_blank"><img src="../images/cheatsheet_easy2use.png" alt="Eiffel Easy2Use Cheatsheet" width="350" /></a>

## Clone the Easy2Use repository

```
git clone https://github.com/eiffel-community/eiffel-easy2use.git
cd eiffel-easy2use
```

## Deploy Your Chosen Easy2Use Bundle
```
./easy2use start <bundle name>
```

## List Deployed Services and User & Passwords
```
./easy2use list <bundle name>
```

## Stop Deployed Services
```
./easy2use remove <bundle name>
```

## Easy2Use CLI Help
If you need to know more about the startup procedures please read the detailed guide below, or use the built-in help in Easy2Use:
```
./easy2use --help
```

## Easy2Use User Configuration

file ./config-user.bash

This file needs to be created manually, this file is NOT tracked by Git.

Configuration examples for Cx bundle to configure Image registry :
```
# Image Registry and Repository
export CX_IMAGE_REGISTRY="registry.hub.docker.com"
export CX_IMAGE_REPOSITORY="myregistry"

# Argo Credentials for Image Registry 
export CX_IMAGE_REPOSITORY_ARGO_K8S_SECRET_USER="myuser"
export CX_IMAGE_REPOSITORY_ARGO_K8S_SECRET_PSW="mypassword"
```
See file ./config-default.bash for more configuration candidates.
