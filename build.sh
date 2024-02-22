#!/bin/sh

# SPDX-FileCopyrightText: 2022 Open Energy Solutions Inc
#
# SPDX-License-Identifier: Apache-2.0

if [ -z "$1" ]; then
    NUM_CORES=`nproc --all`
    echo "defaulting to system processor count: $NUM_CORES"
else
    NUM_CORES=$1
    echo "using supplied processor count: $NUM_CORES"
fi

# build image
docker build -t oesinc/openfmb.adapters.ext --build-arg NUM_CORES=$NUM_CORES .
