#!/bin/bash


export NIX_CHANNEL="http://bbpcf011.epfl.ch/bbp-pkgs/unstable"
export NIX_CACHE_HOST="bbpnixcache.epfl.ch"



## number of cores for -j
## use ncore if present
## or try to get it from /proc if not 
if [[ "$(which ncore 2> /dev/null)x" != "x" ]]; then
	NCORES="$(ncore)" 
else
	NCORES="$(grep -c "processor" /proc/cpuinfo)"
fi

## add 2 process for configure and fetching
let NCORES=${NCORES}+2


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"


function initAllChannels {
	echo "### Install default BBP channel for nix-cache configuration"
	nix-channel --add  $NIX_CHANNEL bbp-pkgs
	nix-channel --update
}

function installNixMonoUser {
	echo "### install Nix in single user mode"
	curl https://nixos.org/nix/install | bash
	source $HOME/.nix-profile/etc/profile.d/nix.sh

}

function setupProxyVM {
	## VM are proxyfied
	export BBP_NETWORK_PROXY=http://bbpfe08.epfl.ch:80/
	echo "### configure Proxy to ${BBP_NETWORK_PROXY} "
	export ALL_PROXY=$BBP_NETWORK_PROXY
	export http_proxy=$BBP_NETWORK_PROXY
	export https_proxy=$BBP_NETWORK_PROXY

}

function collectAllGarbage {
	nix-collect-garbage -d || true
	nix-collect-garbage || true
} 


function setupNixEnvironment {
	echo "### init Nix environment depending of the CI platform"
	HOSTNAME_STRING=$(hostname)
	echo "#### CI hostname ${HOSTNAME_STRING}"

	if [[ "${SKIP_NIX_INSTALL}x" != "x" ]]; then
		return
	fi

	if [[ "${HOSTNAME_STRING}" == *"bg1"* ]]; then
		echo "#### BlueGene/Q environment detected"
		export NODE_IS_BGQ=1
		module load nix 
		return
	fi

	if [[ "$(which nix)" != "" ]]; then
		echo "#### nix tool found in path at $(which nix), skip install"
		return
	fi

	installNixMonoUser
	if [[ "${NODE_NEED_PROXY}x" != "x" ]] || [[ "${HTTP_PROXY}x" != "x" ]]; then
		setupProxyVM
	fi
	initAllChannels

}


function copyClosuresToCache {
	##copy all the closure to the nix server, for later reuse and installation
	if [[ -d /nix/store ]]; then
		ssh-keyscan ${NIX_CACHE_HOST} >> ~/.ssh/known_hosts
		nix-copy-closure --include-outputs -v ${NIX_CACHE_HOST} ${LIST_BUILD_PACKAGES} || true
	fi
}


function loadNixpkgsEnv {
	export NIXPKGS_DIR="$(readlink  -f ${SCRIPT_DIR}/../../sourcethis.sh)"

	echo "### load and use BBPpkgs: ${NIXPKGS_DIR} "
    source ${NIXPKGS_DIR}	

}


function buildDerivationList {
	echo "### Launch build for $@"
 	NB_PKGS="$#"
	echo "#### configured for ${NB_PKGS} derivations"	
	echo "#### parallel build with -j ${NCORES} "

	export PKG_BUILD_DRV=""
	for i in "$@"
	do
		if [[ "${BUILD_BG_CROSS}x" != "x" ]] && [[ "${NODE_IS_BGQ}x" != "x" ]]; then
			export TARGET_DRV=".crossDrv"
		fi
		export PKG_BUILD_DRV="${PKG_BUILD_DRV} -A ${i}${TARGET_DRV}"
	done
	echo "#### arguments to nix-build: ${PKG_BUILD_DRV}"

	set -e
	set -o pipefail
	nix-build ${DERIVATION_PATH} ${PKG_BUILD_DRV} -j $NCORES 2>&1 | tee build_log.txt
	set +o pipefail
	set +e

	export LIST_BUILD_PACKAGES="$(tail -n $NB_PKGS build_log.txt)"


}

function buildAndCopy {
## integrated all-to-go build function
# take list of derivation
# install, configure, build every derivation of the list
# copy the result on the nix cache

echo "## Start build for the derivations: $@"
	export DERIVATION_PATH="./"

	setupNixEnvironment
	loadNixpkgsEnv 

	buildDerivationList $@

	copyClosuresToCache 

}
