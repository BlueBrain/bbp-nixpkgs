{ bluepy
, brainbuilder
, config
, fetchgitPrivate
, flatindexer
, pythonPackages
, stdenv
, voxcell
}:



let
in
pythonPackages.buildPythonPackage rec {
  version = "1.1.1";
  name = "projectionizer-${version}";

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/Projectionizer";
    rev = "1f85d69c122bbf684ac249982eb2e09eae94b0e2";
    sha256 = "1j6bsyqs5zrj9lh1d1cdz34g1br5sid03zw8r7j5v9349si6kpic";
  };

  preConfigure = ''
    # use >= deps and not absolute == to avoid conflicts....
    sed -i 's/==\([^ ]\)/>=\1/g' setup.py
  '';

  buildInputs = with pythonPackages; [
    mock
    nose
  ];

  propagatedBuildInputs = with pythonPackages; [
    bluepy
    brainbuilder
    distributed
    enum34
    flatindexer
    future
    luigi
    matplotlib
    numpy
    pandas
    partd
    pyarrow
    pyyaml
    scipy
    setuptools
    tqdm
    voxcell
  ];

  passthru = {
    pythonDeps = stdenv.propagatedBuildInputs;
  };

  # TODO: Remove this fix when https://github.com/BlueBrain/bbp-nixpkgs/issues/952
  # is fixed
  postPatch = ''
    echo "Removing libFLATIndex dependency for python >= 3.4"
    sed -i -e "s/['\"]libFLATIndex.*$//" setup.py
  '';

  checkPhase = ''
    nosetests
  '';
}
