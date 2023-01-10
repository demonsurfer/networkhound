#!/bin/bash

set -e

scripts_directory="$(dirname $(readlink -f ${BASH_SOURCE}))"
hound_directory="$(dirname ${scripts_directory})"

if test -f "${hound_directory}/server/config.py"; then
    "${hound_directory}/scripts/install_houndserver.sh"
else
    echo "${hound_directory}/server/config.py does not exist. Please create the configuration file first using the generateconfig.py script."
    exit 1
fi
