#!/bin/bash

# SPDX-FileCopyrightText: 2022 Open Energy Solutions Inc
#
# SPDX-License-Identifier: Apache-2.0

# This script stops the scenario 1 of the test plan

pushd examples/scenario-1
docker-compose down
popd

echo "Scenario 1 is stopped"

# Stop HMI
pushd examples/hmi
docker-compose down
popd

echo "HMI is stopped"

