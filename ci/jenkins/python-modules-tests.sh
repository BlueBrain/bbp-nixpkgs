#!/bin/bash

set -e

# list all available modules
module av nix

#
# basic testing on a python full environment
#

function basic_scientific_python_testing {
    # numexpr fails to load: pkg_resources module is missing
    for module in numpy pandas matplotlib.pyplot scipy pycurl bokeh dask ; do
        echo "- import $module"
        ${PYTHON_EXEC} -c "import module"
    done

    echo "- test curl resource outside BBP"
    ${PYTHON_EXEC} - <<EOF
import pycurl

f = open('/dev/null', 'wb')
c = pycurl.Curl()
c.setopt(c.URL, 'http://pycurl.io/')
c.setopt(c.WRITEDATA, f)
c.perform()
c.close()
print("execute pycurl with success")
EOF
}

#
# basic testing in a python light environment
#

function basic_python_light_env {
    rm -rf ~/.cache/pip

    pushd $(mktemp -d)

    echo "- create virtualenv $PWD/venv"
    virtualenv venv
    source venv/bin/activate

    echo "- install the world with pip"

    pip install numpy
    pip install scipy
    pip install pandas
    pip install matplotlib
    patch_wheels

    echo "end pip installation "

    ${PYTHON_EXEC} - <<EOF
import numpy
import scipy
import pandas
import matplotlib
EOF

    echo "import world with success"

    popd
}

#
# test set python 2 full
#
module purge
module load nix/python/2.7-full

echo "## execute test suite for python2 full"

PYTHON_EXEC="python"
basic_scientific_python_testing

echo "## test suite for python2 full run with success"


#
# test set python 2 light
#
module purge
module load nix/python/2.7-light

echo "## execute test suite for python2 light"

PYTHON_EXEC="python"
basic_python_light_env

echo "## test suite for python2 light run with success"





#
# test set python 3 full
#

module purge
module load nix/python/3.6-full

echo "execute tests for python3"

PYTHON_EXEC="python3"

basic_scientific_python_testing

echo "## test suite for python3 run with success"


#
# test set python 3 light
#

module purge
module load nix/python/3.6-light

echo "execute tests for python3"

PYTHON_EXEC="python3"

basic_python_light_env

echo "## test suite for python3 run with success"






