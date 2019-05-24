# This config file can be sourced to prepare a build environment.
source ../../../config-default.bash
source ../../../utilities/cli/cli_utils.bash

source ../component-versions.bash
source ../base-config.bash
source ../docker-base-config.bash
source ../components-configuration.bash

alias build="docker-compose -f docker-compose.yml build"

echo "Build command prepared and ready to be used. To build a service, execute: build <service name>"
