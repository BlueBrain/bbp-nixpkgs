{ stdenv
, bootstrapped-pip
, buildPythonPackage
, isPy3k
, pkgs
, python
}:

# tensorflow is built from a downloaded wheel, because the upstream
# project's build system is an arcane beast based on
# bazel. Untangling it and building the wheel from source is an open
# problem.

buildPythonPackage rec {
  name = "tensorflow-tensorboard-${version}";
  version = "0.4.0rc2";

  src = pkgs.fetchurl (if isPy3k then {
    url = "https://pypi.python.org/packages/df/34/83dfbb2d5d3d89804e8e41effc9700c99c1d02158b4409f5c358e6fa0155/tensorflow_tensorboard-0.4.0rc2-py3-none-any.whl";
    sha256 = "0cv9r2dqp0hy85qs7l2986ifdx86q98xxc5w6xyp6hnkz2h6jcim";
  } else {
    url = "https://pypi.python.org/packages/a0/f4/400505f7635e24d0591c72128aa73c6eb8d6066eab0632bec87ae291c77a/tensorflow_tensorboard-0.4.0rc2-py2-none-any.whl";
    sha256 = "0n71frdcwl44birwxdrvjdjhhg87awwv6syy65d2a13ivw87nya0";
  });

  propagatedBuildInputs = with python.pkgs; [
    bleach_1_5_0
    markdown
    numpy
    protobuf
    setuptools
    six
    werkzeug
  ] ++ pkgs.lib.optional (!isPy3k) futures;

  meta = with stdenv.lib; {
    description = "TensorFlow helps the tensors flow";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
      ## addition to unpack wheel
      unpackPhase = ''
        mkdir dist
        cp $src dist/"''${src#*-}"
      '';

      configurePhase =  ''
        runHook preConfigure
        runHook postConfigure
      '';

      buildPhase = ''
        runHook preBuild
        runHook postBuild
      '';

      preBuild = ''
        echo ${python}/bin/python -m setuptools.
      '';

      installPhase =  ''
        runHook preInstall

        mkdir -p "$out/${python.sitePackages}"
        export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"

        pushd dist
        ${bootstrapped-pip}/bin/pip install *.whl --no-index --prefix=$out --no-cache
        popd

        runHook postInstall
      '';

      doCheck = false;
}
