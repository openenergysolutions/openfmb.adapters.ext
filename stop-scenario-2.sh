#!/bin/bash

# SPDX-FileCopyrightText: 2022 Open Energy Solutions Inc
#
# SPDX-License-Identifier: Apache-2.0

# This script stops the scenario 1 of the test plan

pushd examples/scenario-2
docker-compose down
popd

echo "Scenario 2 is stopped"

# Stop DNP3 master
pushd examples/dnp3-master
docker-compose down
popd

echo "DNP3 master is stopped"

# Stop HMI
pushd examples/hmi
docker-compose down
popd

echo "HMI is stopped"
