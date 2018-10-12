{ boost
, config
, fetchgitPrivate
, git
, hdf5
, highfive
, python3Packages
, spark-bbp
, stdenv
}:

with stdenv.lib; let
  all_deps = with python3Packages; [
      bb5
      docopt
      future
      hdfs
      h5py
      jprops
      lazy_property
      lxml
      progress
      pyarrow
      pyspark
      requests
      sparkmanager
      spark-bbp
      sphinx
      sphinx_rtd_theme
    ]
    ++ optionals enum34Required [ enum34 ]
    ++ optionals pathlib2Required [ pathlib2 ]
    ;

  python-env = python3Packages.python.buildEnv.override {
    extraLibs = all_deps;
  };
  python = python3Packages.python;
  enum34Required = !versionAtLeast python.pythonVersion "3.4";
  pathlib2Required = !versionAtLeast python.pythonVersion "3.6";
in

  stdenv.mkDerivation rec {
    name = "spykfunc-${version}";
    version = "0.10.2";
    meta = {
      description = "New Functionalizer implementation on top of Spark";
      longDescription = ''
        Functionalizer takes as input the touches information output by the
        BlueDetector and applies the distributed approach of parallel
        transposition of a matrix (representing neurons connections), in order
        to perform several steps of filtering and output the final synapses as
        hdf5 files. It does all IO operations using MPI IO and hdf5 IO - uses
        parallel hdf5 when available.
      '';
      platforms = platforms.unix;
      homepage = "https://bbpteam.epfl.ch/project/spaces/display/BBPHPC/Spark+functionalizer";
      repository = "ssh://bbpcode.epfl.ch/building/Spykfunc";
      license = {
        fullName = "Copyright 2018, Blue Brain Project";
      };
      maintainers = [
        config.maintainers.ferdonline
        config.maintainers.matz-e
      ];
    };
    src = fetchgitPrivate {
      url = config.bbp_git_ssh + "/building/Spykfunc";
      rev = "e2c587f0aa51a89bf68eb7c1bae2afd5d372cbdb";
      sha256 = "1j9xyhyvahiiz713w4pvffv66fi50s4lps72r4rxc5h1p8mmn39r";
    };
    buildInputs = [ boost git hdf5 highfive ];
    nativeBuildInputs = [
      python-env
    ];
    outputs = [ "out" "doc" ];

    propagatedBuildInputs = all_deps;

    preConfigure = optionalString (!enum34Required) "\nsed -i '/enum34;python_version/d' setup.py"
                 + optionalString (!pathlib2Required) "\nsed -i '/pathlib2/d' setup.py";

    buildPhase = ''
      runHook preBuild

      mkdir -p $out
      export PYTHONPATH=${python3Packages.setuptools}/${python.sitePackages}:$PYTHONPATH}
      for target in build docs; do
        echo "buildPhase: executing target $target"
        ${python-env.interpreter} setup.py $target
      done

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/${python.sitePackages}"

      export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"
      echo $PYTHONPATH

      echo "installPhase: install package in $out"
      ${python-env.interpreter} setup.py install \
        --install-lib=$out/${python.sitePackages} \
        --old-and-unmanageable \
        --prefix="$out"

      mkdir -p $out/share/doc
      cp -r docs/_build/html $out/share/doc/

      runHook postInstall
    '';

    passthru = {
      pythonModule = python3Packages.python;
      pythonPackages = python3Packages;
    };
  }
