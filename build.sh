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

# get the private repo so that we can avoid having to copy a private key into docker image
if [ ! -d internal-openfmb.adapters ]; then
    git clone --recursive --branch v2.1.0 git@github.com:openenergysolutions/internal-openfmb.adapters.git
fi

# UDP adapters
if [ ! -d openfmb.adapters.udp ]; then
    git clone git@github.com:openenergysolutions/openfmb.adapters.udp.git
fi

# launcher
if [ ! -d openfmb.adapters.launcher ]; then
    git clone git@github.com:openenergysolutions/openfmb.adapters.launcher.git
fi

# build image
docker build -t oesinc/openfmb.adapters.ext:pre-release --build-arg NUM_CORES=$NUM_CORES .
