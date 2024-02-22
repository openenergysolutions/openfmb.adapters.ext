#!/bin/bash

# SPDX-FileCopyrightText: 2022 Open Energy Solutions Inc
#
# SPDX-License-Identifier: Apache-2.0

# This script runs the scenario 1 of the test plan

# replace IP address with the IP address from HOST_IP_ADDRESS environment variable
# prompt for IP address
echo "Enter the IP address of the host machine"
read HOST_IP_ADDRESS

HOST_IP_ADDRESS=$HOST_IP_ADDRESS ./replace-ip-address.sh

pushd examples/scenario-1
docker-compose up -d
popd

echo "Scenario 1 is running. Now start HMI to see the data"

# Start HMI
pushd examples/hmi
docker-compose up -d
popd

echo "HMI is running. Open the browser and go to http://$HOST_IP_ADDRESS:32771 to see the data"
