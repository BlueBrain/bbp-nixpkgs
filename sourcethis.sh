#!/bin/bash


export NIXPKG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

# setup SSH for gerrit access
export NIX_PATH="ssh-config-file=$HOME/.ssh/config:$NIX_PATH"


# and setup the BBP nixpkgs"
export NIX_PATH="BBPpkgs=${NIXPKG_DIR}:${NIX_PATH}"


echo "### setup NIX_PATH as"
echo "export NIX_PATH=${NIX_PATH}"

