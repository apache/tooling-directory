#!/bin/sh
# What `docker compose up` runs (see compose.yaml): copy the tree in, make a certificate,
# write a development config.yaml, and start the dev server.

set -eu

if [ -d /tmp/directory ]
then
    echo "This script must be run in a clean container; run docker compose down first!"
    exit 1
fi

# Source is mounted at /mnt
# /run/directory/.venv and /run/directory/assets/node_modules are mounted
# from external volumes so we don't want to overwrite them

# copy locally so changes don't affect host
rm -rf /tmp/directory
cp -Rp /mnt /tmp/directory

# don't want host versions of these
rm -rf /tmp/directory/state
rm -rf /tmp/directory/.venv
rm -rf /tmp/directory/assets/.yarn/install-state.gz
rm -rf /tmp/directory/assets/node_modules
rm -rf /tmp/directory/.git
rm -rf /tmp/directory/.github
rm -rf /tmp/directory/app/client/static/assets

# move what's left across, avoiding any overwrites
cd /tmp/directory
find . -type d -exec mkdir -p /run/directory/{} \;
find . -type f -exec mv -n {} /run/directory/{} \;

cd /run/directory

# replace app copies with links (generated files were dropped above)
find app -type f -exec ln -sf /mnt/{} /run/directory/{} \;

# Get cert data from cache if possible
if [ -r /run/cert/cert.pem ] && [ -r /run/cert/key.pem ]
then
    echo "Found existing cert pair"
    mkdir -p state
    cp /run/cert/*.pem state
else
    echo "Creating a new cert pair"
    make certs # create the certs
    # Safety first: we don't need the key any more
    rm "$(mkcert -CAROOT)/rootCA-key.pem"

    # cache for next time
    cp state/*.pem /run/cert
    cp "$(mkcert -CAROOT)/rootCA.pem" /run/cert

    # make it easy to fetch the cert if needed
    cp "$(mkcert -CAROOT)/rootCA.pem" state
fi

# The config.yaml copied from /mnt is the one CONTRIBUTING.md has you write, with its roles: kept.
[ -f config.yaml ] || cp config.yaml.example config.yaml
sed -i 's|host: localhost|host: 0.0.0.0|' config.yaml

make sync
make init
# the frontend's dependencies, and a first bundle: the watcher `make dev` starts imports its plugins
make build

make dev
