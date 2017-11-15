{ stdenv
, fetchurl
, isPy35 ? null
, isPy27 ? null
, cudaSupport ? false
, cudatoolkit ? null
, cudnn ? null
, linuxPackages ? null
, pythonPackages
, swig
, zlib
, glibcLocales
}:

assert cudaSupport -> cudatoolkit != null
                   && cudnn != null
                   && linuxPackages != null;

# unsupported combination
assert ! (stdenv.isDarwin && cudaSupport);

# tensorflow is built from a downloaded wheel, because the upstream
# project's build system is an arcane beast based on
# bazel. Untangling it and building the wheel from source is an open
# problem.


let
  installFlags = [];

  buildPythonPackage = pythonPackages.buildPythonPackage;

  bootstrapped-pip = pythonPackages.bootstrapped-pip;
  python = pythonPackages.python;

  self = buildPythonPackage rec {
    pname = "tensorflow";
    version = "1.4.0";
    name = "${pname}${if cudaSupport then "-gpu" else ""}-${version}";
    format = "wheel";
    disabled = false;

    src =
      if python.majorVersion == "2.7"
      then
        if cudaSupport
        then
            fetchurl {
              url = "http://bbpobjectstorage.epfl.ch:81/swift/v1/nix-data/tensorflow/gpu/tensorflow-${version}-cp27-cp27mu-linux_x86_64.whl";
              sha256 = "1cpv1f1rl3xf6j4502n3zz6pwpam1s5z7zzs4hxvsirnxdd6bs5c";
            }
        else
            fetchurl {
              url = "http://bbpobjectstorage.epfl.ch:81/swift/v1/nix-data/tensorflow/cpu/tensorflow-${version}-cp27-cp27mu-linux_x86_64.whl";
              sha256 = "1ijh8rns7ir3cj4lklk9i9z2vm76pibwpqq2yg55mswmz4sxaqhc";
            }
      else
        if cudaSupport
        then
          fetchurl {
            url = "http://bbpobjectstorage.epfl.ch:81/swift/v1/nix-data/tensorflow/gpu/tensorflow-${version}-cp34-cp34m-linux_x86_64.whl";
            sha256 = "0bqw05k4q6jm4vz7hl3wz1lpz9fpinj7lym3z5bmj3v0f8pa9rgi";
          }
        else
          fetchurl {
            url = "http://bbpobjectstorage.epfl.ch:81/swift/v1/nix-data/tensorflow/cpu/tensorflow-${version}-cp34-cp34m-linux_x86_64.whl";
            sha256 = "dfdcyz5ag2mksxci52kg517hyvfz4fyqpcxbfsdvqn1b7g3yqw13";
          }
      ;

    propagatedBuildInputs = with stdenv.lib; with pythonPackages;
      [
        backports_weakref
        bootstrapped-pip
        mock
        numpy
        protobuf
        six
        swig
        setuptools
        tensorflow-tensorboard
      ]
      ++ optionals cudaSupport [ cudatoolkit cudnn stdenv.cc ]
      ++ optionals (!pythonAtLeast "3.4") [ enum34 ]
      ;

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

      installPhase =  ''
        runHook preInstall

        mkdir -p "$out/${python.sitePackages}"
        export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"

        pushd dist
        ${bootstrapped-pip}/bin/pip install *.whl --no-index --prefix=$out --no-cache ${toString installFlags} --build tmpbuild
        popd

        rm -f $out/bin/tensorboard

        runHook postInstall
      '';

      # Note that we need to run *after* the fixup phase because the
      # libraries are loaded at runtime. If we run in preFixup then
      # patchelf --shrink-rpath will remove the cuda libraries.
      postFixup = let
        rpath = "${stdenv.lib.getLib stdenv.cc.cc}/lib:${zlib}/lib";
      in
      ''
        echo "rpath: ${rpath}"
        find $out -name '*.so' -exec patchelf --set-rpath "${rpath}" {} \;
      '';

      doCheck = false;

      passthru = {
        site-packages = "lib/${python.libPrefix}/site-packages/tensorflow";
      };

    };
in
self
