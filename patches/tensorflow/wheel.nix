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

  python = pythonPackages.python;

  numpy = pythonPackages.numpy;

  six = pythonPackages.six;
  
  mock = pythonPackages.mock2;

  protobuf3_2 = pythonPackages.protobuf3_2;

  bootstrapped-pip = pythonPackages.bootstrapped-pip;

  werkzeug = pythonPackages.buildPythonPackage rec {
    name = "Werkzeug-0.11.10";

    src = fetchurl {
      url = "mirror://pypi/W/Werkzeug/${name}.tar.gz";
      sha256 = "1vpf98k4jp4yhbv2jbyq8dj5fdasrd26rkq34pacs5n7mkxxlr6c";
    };

    LC_ALL = "en_US.UTF-8";

    propagatedBuildInputs = with pythonPackages; [ itsdangerous ];
    buildInputs = with pythonPackages; [ pytest requests2 glibcLocales ];

  };

  self = pythonPackages.buildPythonPackage rec {
      pname = "tensorflow";
      version = "1.1.0";
      name = "${pname}-${version}";
      format = "wheel";
      disabled = false;

      src = fetchurl {
        url = "https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-${version}-cp27-none-linux_x86_64.whl";
        sha256 = "0ld3hqx3idxk0zcrvn3p9yqnmx09zsj3mw66jlfw6fkv5hznx8j2";
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

      installPhase =  ''
        runHook preInstall

        mkdir -p "$out/${python.sitePackages}"
        export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"

        pushd dist
        ${bootstrapped-pip}/bin/pip install *.whl --no-index --prefix=$out --no-cache ${toString installFlags} --build tmpbuild
        popd

        runHook postInstall
      '';

        
      propagatedBuildInputs = with stdenv.lib;
        [ numpy six protobuf3_2 swig werkzeug mock ]
        ++ optionals cudaSupport [ cudatoolkit cudnn stdenv.cc ];

      # Note that we need to run *after* the fixup phase because the
      # libraries are loaded at runtime. If we run in preFixup then
      # patchelf --shrink-rpath will remove the cuda libraries.
      postFixup = let
        rpath = "${stdenv.cc.cc}/lib:${zlib}/lib";
          
      in
      ''
        echo "rpath: ${rpath}"
        find $out -name '*.so' -exec patchelf --set-rpath "${rpath}" {} \;
      '';

      doCheck = false;

      passthru = {
                pythonDeps =   (pythonPackages.gatherPythonRecDep self);
      };



    };
in

 self

