#!/bin/bah

set -eu -o pipefail

readonly uploadsDir="${UPLOADS_DIR:-/opt/stacksmith/user-uploads}"

installGolang() {
  echo "  Installing Golang..."
  curl -sSL https://dl.google.com/go/go1.12.linux-amd64.tar.gz | tar -C /usr/local -xz
  ln -s /usr/local/go/*bin/* /usr/local/bin/
}

installUploadedPlugins() {
  echo "Installing uploaded plugins from ${uploadsDir}..."
  for plugin in $(find "${uploadsDir}" -name '*.hpi' -or -name '*.jpi') ; do
    echo "  Installing ${plugin}..."
    mv "${plugin}" /opt/bitnami/jenkins/plugins/
  done
}

installPlugin() {
  local url="${1:?Plugin URL required}"

  echo "  Installing plugin from ${url}..."
  cd /opt/bitnami/jenkins/plugins
  curl -O -sSL "${url}"
}

# install Go
installGolang

# install a specific version of script-security plugin
rm -fR /opt/bitnami/jenkins/plugins/script-security*
installPlugin https://updates.jenkins.io/download/plugins/script-security/1.54/script-security.hpi

# install plugins uploaded to Stacksmith
installUploadedPlugins

# install a plugin via URL
installPlugin https://updates.jenkins.io/download/plugins/golang/1.2/golang.hpi

echo "Customizations applied"
