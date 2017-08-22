{ pkgs, fetchurl, pythonPackages, buildPythonPackage }:

let
    openblas = pkgs.openblasCompat;
in
buildPythonPackage rec {
  name = "numpy-1.13.1";

  src = fetchurl {
    url = "mirror://pypi/n/numpy/numpy-1.13.1.zip";
    sha256 = "c9b0283776085cb2804efff73e9955ca279ba4edafd58d3ead70b61d209c4fbb";
  };

  doCheck = false;

  preConfigure = ''
    sed -i 's/-faltivec//' numpy/distutils/system_info.py
    sed -i '0,/from numpy.distutils.core/s//import setuptools;from numpy.distutils.core/' setup.py

    export LAPACK="${openblas}/lib/libopenblas.so"
    export BLAS="${openblas}/lib/libopenblas.so"
    export OPENBLAS="${openblas}/lib/libopenblas.so"
    export MKL=None
    export PTATLAS=None
    export ATLAS=None
    '';

  setupPyBuildFlags = ["--fcompiler='gnu95'"];

  buildInputs = [ pkgs.gfortran pythonPackages.nose openblas ];

  meta = {
    description = "Scientific tools for Python";
    homepage = "http://numpy.scipy.org/";
  };
}
