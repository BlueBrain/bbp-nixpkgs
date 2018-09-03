{ stdenv
, python
, pythonPackages
}:


let
in
pythonPackages.buildPythonPackage rec {
  pname = "neurom";
  version = "1.4.8";
  name = "${pname}-${version}";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "128zr45hvlq2c2db93wbjfbi0xp9bs6p6zjydazarwnwkv7fhi5c";
  };

  propagatedBuildInputs = with pythonPackages; [
    enum34
    future
    scipy
    numpy
    pyyaml
    tqdm
    matplotlib
    h5py
    pylru
    plotly
  ];

  passthru = {
    pythonDeps = propagatedBuildInputs;
  };

  enum34Required = !stdenv.lib.versionAtLeast python.pythonVersion "3.4";

  postPatch = (stdenv.lib.optionalString enum34Required ''
            echo "Removing enum34 dependency for python >= 3.4"
            sed -i -e "s/['\"]enum34.*$//" setup.py
  '');

  doCheck = false;
}
