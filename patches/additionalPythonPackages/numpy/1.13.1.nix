{ pkgs, fetchurl, pythonPackages, buildPythonPackage }:

let
    openblas = pkgs.openblasCompat;
in
buildPythonPackage rec {
  name = "numpy-1.13.3";

  src = fetchurl {
    url = "mirror://pypi/n/numpy/${name}.zip";
    sha256 = "0l576ngjbpjdkyja6jd16znxyjshsn9ky1rscji4zg5smpaqdvin";
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
