#!/bin/sh
#
# Copyright (C) 2020 James Fuller <jim.fuller@webcomposite.com>
#
# SPDX-License-Identifier: MIT
#

set -e
while true
do
  curl "$@"
  sleep 10m
done

