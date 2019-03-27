#!/bin/bash

set -eu -o pipefail

stacksmithNewApp() {
  local project="${1:?Project required}"
  local name="${2:?Name required}"
  local target="${3:-docker}"

  rm -f Stackerfile.yml_
  mv Stackerfile.yml Stackerfile.yml_
  stacksmith init --project "${project}" --name "${name}" --target "${target}"
  local appIdLine="$(grep "^appId:" <Stackerfile.yml)"
  local appNameLine="$(grep "^appName:" <Stackerfile.yml)"
  sed "s#^appId:.*\$#${appIdLine}#;s#^appName.*\$#${appNameLine}#" <Stackerfile.yml_ >Stackerfile.yml
  rm -f Stackerfile.yml_
}

stacksmithNewApp "${1:?Project required}" "${2:?Name required}"

