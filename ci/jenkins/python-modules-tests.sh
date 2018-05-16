#!/bin/bash

set -e

# list all available modules
module av nix

#
# basic testing on a python full environment
#

function basic_scientific_python_testing {
    for module in numpy pandas matplotlib.pyplot scipy pycurl bokeh dask seaborn numexpr; do
        echo "- import $module"
        ${PYTHON_EXEC} -c "import $module"
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

    echo "- test requests outside BBP"
    ${PYTHON_EXEC} - <<EOF
import sys
import requests

r = requests.get('http://pycurl.io/')
if r.status_code != 200:
    sys.exit(1)
EOF

    echo "- test bokeh"
    ${PYTHON_EXEC} - <<EOF
from bokeh.plotting import figure, output_file, save

# prepare some data
x = [1, 2, 3, 4, 5]
y = [6, 7, 2, 4, 5]

# output to static HTML file
output_file("seaborn.html")

# create a new plot with a title and axis labels
p = figure(title="simple line example", x_axis_label='x', y_axis_label='y')

# add a line renderer with legend and line thickness
p.line(x, y, legend="Temp.", line_width=2)
save(p)
EOF

    echo "- test seaborn"
    ${PYTHON_EXEC} - <<EOF
import seaborn as sns
df = sns.load_dataset('iris')
sns_plot = sns.pairplot(df, hue='species', size=2.5)
sns_plot.savefig("seaborn.png")
EOF

    echo "- test dask"
    ${PYTHON_EXEC} - <<EOF
import dask.array as da

x = da.random.normal(10, 0.1, size=(20000, 20000), chunks=(1000, 1000))
y = x.mean(axis=0)[::100]
y.compute()
EOF
}

#
# basic testing in a python light environment
#

function basic_python_light_env {
    rm -rf ~/.cache/pip

    pushd $(mktemp -d)

    echo "- create virtualenv $PWD/venv"
    echo "  virtualenv is " `which virtualenv`
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






