#!/bin/bash

set -e

# list all available modules
module av


#
# basic testing on a python full environment
#

function basic_scientific_python_testing {
${PYTHON_EXEC} -c "import numpy"

${PYTHON_EXEC} -c "import pandas"

${PYTHON_EXEC} -c "import matplotlib.pyplot as plt"

${PYTHON_EXEC} -c "import scipy"

${PYTHON_EXEC} - <<EOF

import pycurl
from StringIO import StringIO

buffer = StringIO()
c = pycurl.Curl()
c.setopt(c.URL, 'http://pycurl.io/')
c.setopt(c.WRITEDATA, buffer)
c.perform()
c.close()

EOF



}


#
# test set python 2
#
module purge
module load nix/python/2.7-full

PYTHON_EXEC="python"
basic_scientific_python_testing


#
# test set python 3
#

module purge
module load nix/python/3.6-full

PYTHON_EXEC="python3"

basic_scientific_python_testing


