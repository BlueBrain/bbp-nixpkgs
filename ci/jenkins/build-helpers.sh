#!/bin/bash


export NIX_CHANNEL="https://bbpobjectstorage.epfl.ch/nix-channel"
export NIX_CACHE_HOST="bbpnixcache.epfl.ch"

export BBP_NETWORK_PROXY="http://bbpproxy.epfl.ch:80/"

## number of cores for -j
## use ncore if present
## or try to get it from /proc if not
if [[ "$(which ncore &>/dev/null)x" != "x" ]]; then
	NCORES="$(ncore)"
elif [ -f /proc/cpuinfo ] ;then
	NCORES="$(grep -c "processor" /proc/cpuinfo)"
else
	# OSX
	NCORES="$(sysctl -n hw.ncpu)"
fi

## add 2 process for configure and fetching
let NCORES=${NCORES}+2


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

## Mimic "readlink -f" behavior because the option not available on MacOS.
function readlink_f {
	local -r TARGET_FILE="$1" cwd="$PWD" PHYS_DIR RESULT

	cd `dirname $TARGET_FILE`
	TARGET_FILE=`basename $TARGET_FILE`

	# Iterate down a (possible) chain of symlinks
	while [ -L "$TARGET_FILE" ]
	do
	    TARGET_FILE=`readlink $TARGET_FILE`
	    cd `dirname $TARGET_FILE`
	    TARGET_FILE=`basename $TARGET_FILE`
	done

	# Compute the canonicalized name by finding the physical path
	# for the directory we're in and appending the target file.
	PHYS_DIR=`pwd -P`
	RESULT=$PHYS_DIR/$TARGET_FILE
	cd "$cwd"
	echo $RESULT
}

function initAllChannels {
	echo "### Install default BBP channel for nix-cache configuration"
	nix-channel --add  $NIX_CHANNEL bbp-pkgs
	nix-channel --update
}

function installNixMonoUser {
	echo "### install Nix in single user mode"
	pushd $(mktemp -d)
		export NIX_VERSION="1.11.16"
		curl -L https://nixos.org/releases/nix/nix-${NIX_VERSION}/nix-${NIX_VERSION}-x86_64-linux.tar.bz2 -o nix-${NIX_VERSION}-x86_64-linux.tar.bz2
		tar xf nix-${NIX_VERSION}-x86_64-linux.tar.bz2
		./nix-${NIX_VERSION}-x86_64-linux/install	
	popd
	source $HOME/.nix-profile/etc/profile.d/nix.sh

}

function setupProxyVM {
	## VM are proxyfied
	echo "### configure Proxy to ${BBP_NETWORK_PROXY} "
	export ALL_PROXY=$BBP_NETWORK_PROXY
	export http_proxy=$BBP_NETWORK_PROXY
	export https_proxy=$BBP_NETWORK_PROXY

}

function collectAllGarbage {
	if [[ "${NODE_IS_BGQ}x" == "x" ]]; then
		nix-collect-garbage --delete-older-than 30d || true
	fi
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

	if [[ "$(which nix-build)" != "" ]]; then
		echo "#### nix tool found in path at $(which nix-build), skip install"
	else
		installNixMonoUser
	fi

	if [[ "${NODE_NEED_PROXY}x" != "x" ]] || [[ "${HTTP_PROXY}x" != "x" ]] || [[ "${http_proxy}x" != "x"  ]]; then
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
	export NIXPKGS_DIR="$(readlink_f ${SCRIPT_DIR}/../../sourcethis.sh)"

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
	nix-build --show-trace ${DERIVATION_PATH} ${PKG_BUILD_DRV} -j $NCORES 2>&1 --option require-sigs false | tee build_log.txt
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

	collectAllGarbage

}
