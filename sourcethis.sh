#!/bin/bash


export NIXPKG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"



function LocalMachineSSHSetup {

    # setup SSH for gerrit access
    if [[ "${NIX_PATH}"  != *"ssh-config-file"* ]]; then
    	export NIX_PATH="ssh-config-file=$HOME/.ssh/config:$NIX_PATH"
    fi


    # setup SSH agent forwarding
    if [[ "${SSH_AUTH_SOCK}x" != "x" ]]; then
    	export NIX_PATH="ssh-auth-sock=${SSH_AUTH_SOCK}:${NIX_PATH}"
    fi
}


function vizClusterSSHSetup {
   
    # setup SSH for git access on viz cluster at BBP
    echo "Enable BBP viz cluster configuration"

    export NIX_PATH="ssh-config-file=/etc/nix/ssh/config/config:$NIX_PATH"

}

function BBPnixpkgsSetup {
    # and setup the BBP nixpkgs"
    export NIX_PATH="BBPpkgs=${NIXPKG_DIR}:${NIX_PATH}"
    export NIX_PATH="nixpkgs=${NIXPKG_DIR}:${NIX_PATH}"
}



BBPnixpkgsSetup

if [[ "$(hostname)" == *viz* || "$(hostname)" == *bbptadm* || "$(hostname)" == *bbpv* || "$(hostname)" == r*i*n* || "$(hostname)" == tds* ]]; then
    vizClusterSSHSetup
else
    LocalMachineSSHSetup
fi



echo "### setup NIX_PATH as"
VAL_EXPORT="export NIX_PATH=${NIX_PATH}"
echo "$VAL_EXPORT"
eval "$VAL_EXPORT"

