#!/bin/bash

# This script setup the basic environment needed to use nix in the HBP/BBP 
# 
# WARNING: Due to the security policy and access restriction on the BBP source code
#          a valid SSH access to the BBP/HBP gerrit repository is REQUIRED by any Installation
#  
#          to test your SSH environment please run "git clone ssh://bbpcode.epfl.ch/common/config.bbp"
#               In case of failure, please refer to the SSH documentation to setup a valid environment

# export 
pushd `dirname ${BASH_SOURCE[0]}` > /dev/null
NIXEXP_PATH=`pwd`
popd > /dev/null
echo "*** setup BBP nixpkgs expression to $NIXEXP_PATH"

rm ~/.nix-defexpr
ln -s $NIXEXP_PATH ~/.nix-defexpr

# try to save the world by setting up minimalist SSH env if not existing
mkdir -m 0700 -p ~/.ssh
touch ~/.ssh/config




# forward to nix environment all SSH credential
export NIX_PATH="ssh-auth-sock=$SSH_AUTH_SOCK:$NIX_PATH"
export NIX_PATH="ssh-config-file=$HOME/.ssh/config:$NIX_PATH"

# export nixpkg
export NIX_PATH="nixpkgs=$NIXEXP_PATH/default.nix:$NIX_PATH"



