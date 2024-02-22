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

pushd examples/scenario-2
docker-compose up -d
popd

echo "Scenario 2 is running. Now start DNP3 master and HMI to see the data"

# Start DNP3 master
pushd examples/dnp3-master
docker-compose up -d
popd

# Start HMI
pushd examples/hmi
docker-compose up -d
popd

echo "DNP3 master and HMI are running. Open the browser and go to http://$HOST_IP_ADDRESS:32771 to see the data"

