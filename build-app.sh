#!/bin/bash

set -eu -o pipefail

if [ "${STACKSMITH_NEW_APP}" != "" ] ; then
  echo "INIT"
else
  echo "NO INIT"
fi

