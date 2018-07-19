{ stdenv
, config
, fetchgitPrivate
, pythonPackages
}:


let
  pytouchreader = pythonPackages.buildPythonPackage rec {
    name = "pytouchreader-${version}";
    version = "1.1.0";

    meta = {
      description = "A Python utility to read raw binary touches efficiently";
      longDescription = ''
      '';
      platform = stdenv.lib.platforms.unix;
      homepage = "https://documents.epfl.ch/groups/b/bb/bbp-dev-hpc/www/pytouchreader";
      repository = "ssh://bbpcode.epfl.ch/hpc/PyModules";
      license = {
        fullName = "Copyright 2017, Blue Brain Project";
      };
      maintainers = [
        config.maintainers.ferdonline
      ];
      # Override documentation package name because
      # buildPythonPackage prefix `name` by "pythonMAJOR.MINOR-"
      docname = name;
    };

    src = fetchgitPrivate {
      url = config.bbp_git_ssh + "/hpc/PyModules";
      rev = "d0795eaac05c91414a6639eb5d96b493cdad8df9";
      sha256 = "0wbc0yhfyl9chslgjrn00pjs6cli6s46sqvr6i76sr7lqhi5vx5j";
    };

    propagatedBuildInputs = [
      pythonPackages.future
      pythonPackages.lazy_property
      pythonPackages.numpy
      pythonPackages.simplegeneric
    ];

    passthru = {
      pythonDeps = pythonPackages.gatherPythonRecDep pytouchreader;
    };

    preConfigure = ''
      cd PyTouchReader;
      rm dist/*.whl
    '';

    postInstall = ''
      mkdir -p $out/share/doc
      src="$PWD"
      pushd $out/share/doc
      tar zxf "$src/docs/_build/PyTouchReader-1.0.0-docs-html.tgz"
      popd
    '';

    outputs = ["out" "doc"];
  };
in
  pytouchreader
