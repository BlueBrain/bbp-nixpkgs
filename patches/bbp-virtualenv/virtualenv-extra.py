"""
Virtualenv hooks
"""

import distutils.sysconfig
import os.path as osp


def extend_parser(optparse_parser):
    """You can add or remove options from the parser here."""


def adjust_options(options, args):
    """
    You can change options here, or change the args (if you accept
    different kinds of arguments, be sure you modify ``args`` so it is
    only ``[DEST_DIR]``).
    """

def after_install(options, home_dir):
    """After everything is installed, this function is called."""
    major_minor = distutils.sysconfig.get_python_version()
    lib_dir = osp.join(home_dir, 'lib', 'python' + major_minor)
    manylinux_mod = osp.join(lib_dir, '_manylinux.py')
    if not osp.exists(manylinux_mod):
        with open(manylinux_mod, 'w') as ostr:
            ostr.write('manylinux1_compatible = True\n')
