#!/bin/bash

set -eu -o pipefail

if [ "${STACKSMITH_NEW_APP:-}" != "" ] ; then
  if [ "${STACKSMITH_NEW_APP_NAME:-}" = "" ] ; then
    echo >&2 "Application name must be specified"
    exit 1
  fi

  ./init-new-app.sh aws-demo-bitnami "${STACKSMITH_NEW_APP_NAME}"
else
  echo "Building existing application"
fi

stacksmith build

git reset --hard

