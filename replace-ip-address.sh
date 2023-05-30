#!/bin/sh

# SPDX-FileCopyrightText: 2022 Open Energy Solutions Inc
#
# SPDX-License-Identifier: Apache-2.0

if [ -z "${HOST_IP_ADDRESS}" ]; then
  echo 'HOST_IP_ADDRESS environment is not set'
else
  find ./examples \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i "s/REPLACE_HOST_IP_ADDRESS/$HOST_IP_ADDRESS/g"
fi