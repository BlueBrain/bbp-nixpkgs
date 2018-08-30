{ stdenv
, pythonPackages
}:


let
in
pythonPackages.buildPythonPackage rec {
  pname = "neurom";
  version = "1.4.9";
  name = "${pname}-${version}";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "1vrjap7l89r7ik50p2hr9dvm17cd4q1gcpf5xlhb3qfa31jwkgsm";
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
}
