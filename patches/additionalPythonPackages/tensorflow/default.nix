{ stdenv, buildBazelPackage, lib, fetchFromGitHub, fetchpatch, symlinkJoin
, buildPythonPackage, isPy3k, pythonOlder, pythonAtLeast
, which, swig, binutils, glibcLocales
, python, jemalloc, openmpi
, pythonPackages
, cudaSupport ? false, nvidia_x11 ? null, cudatoolkit ? null, cudnn ? null, nccl ? null
# XLA without CUDA is broken
, xlaSupport ? cudaSupport
# Default from ./configure script
, cudaCapabilities ? [ "3.5" "5.2" "7.0" ]
, avxSupport ? true
, avx2Support ? false
, fmaSupport ? false
}:

assert cudaSupport -> nvidia_x11 != null
                   && cudatoolkit != null
                   && cudnn != null;

# unsupported combination
assert ! (stdenv.isDarwin && cudaSupport);

let

  withTensorboard = pythonOlder "3.6";

  cudatoolkit_joined = symlinkJoin {
    name = "${cudatoolkit.name}-unsplit";
    paths = [ cudatoolkit.out cudatoolkit.lib ];
  };

  tfFeature = x: if x then "1" else "0";

  version = "1.8.0";

  pkg = buildBazelPackage rec {
    name = "tensorflow-build-${version}";

    src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "tensorflow";
      rev = "v${version}";
      sha256 = "18hydad4d61qg5ji7frcbmhb1l09s122n9hl7ic0nqq6j786acvv";
    };

    patches = [
	# Fix compilation issues with GCC 6.4.0
	(fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/tensorflow/tensorflow/pull/18434.patch";
        sha256 = "0lpfq66bqijxnn80zfxpcj4f7j01a32avjxcfz2fhlivj4qyar96";
      })

    ];

    nativeBuildInputs = [ swig which ];

    buildInputs = [ python jemalloc openmpi glibcLocales pythonPackages.numpy ]
      ++ lib.optionals cudaSupport [ cudatoolkit cudnn nvidia_x11 nccl ];

    propagatedBuildInputs = [ pythonPackages.astor pythonPackages.numpy pythonPackages.six pythonPackages.protobuf pythonPackages.absl-py ]
                 ++ lib.optional (!isPy3k) pythonPackages.mock
                 ++ lib.optionals (pythonOlder "3.4") [ pythonPackages.backports_weakref pythonPackages.enum34 ];

    preTFConfigure = ''
      set -x
      echo "hello world"
      patchShebangs configure

      export PYTHON_BIN_PATH="${python.interpreter}"
      export PYTHON_LIB_PATH="$NIX_BUILD_TOP/site-packages"
      export TF_NEED_GCP=1
      export TF_NEED_HDFS=1
      export TF_ENABLE_XLA=${tfFeature xlaSupport}
      export CC_OPT_FLAGS=" "
      # https://github.com/tensorflow/tensorflow/issues/14454
      export TF_NEED_MPI=${tfFeature cudaSupport}
      export TF_NEED_CUDA=${tfFeature cudaSupport}
      ${lib.optionalString cudaSupport ''
        export CUDA_TOOLKIT_PATH=${cudatoolkit_joined}
        export TF_CUDA_VERSION=${cudatoolkit.majorVersion}
        export CUDNN_INSTALL_PATH=${cudnn}
        export TF_CUDNN_VERSION=${cudnn.majorVersion}
        export GCC_HOST_COMPILER_PATH=${cudatoolkit.cc}/bin/gcc
        export TF_CUDA_COMPUTE_CAPABILITIES=${lib.concatStringsSep "," cudaCapabilities}
        export NCCL_INSTALL_PATH="${nccl}"
	export TF_NCCL_VERSION="1.3"
      ''}

      mkdir -p "$PYTHON_LIB_PATH"
    '';

    dontAddPrefix = true;

    configurePhase = ''
		eval "$preTFConfigure"

		mkdir -p $out
		./configure --workspace=$out 
		
		export NIX_TF_ADD_FLAGS="-O2 -ftree-vectorize ${if avxSupport then ''-mavx'' else ''''}"
		export NIX_TF_ADD_FLAGS="$NIX_TF_ADD_FLAGS ${if avx2Support then ''-mavx2'' else ''''}"
		export NIX_TF_ADD_FLAGS="$NIX_TF_ADD_FLAGS ${if fmaSupport then ''-mfma'' else ''''}"

		export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $NIX_TF_ADD_FLAGS"
		export NIX_CXXFLAGS_COMPILE="$NIX_CXXFLAGS_COMPILE $NIX_CFLAGS_COMPILE"
    '';

    NIX_LDFLAGS = lib.optionals cudaSupport [ "-lcublas" "-lcudnn" "-lcuda" "-lcudart" ];

    hardeningDisable = [ "all" ];

    bazelFlags = [ ] ++  lib.optional cudaSupport "--config=cuda";

    bazelTarget = "//tensorflow/tools/pip_package:build_pip_package";

    fetchAttrs = {
      preInstall = ''
        rm -rf $bazelOut/external/{bazel_tools,\@bazel_tools.marker,local_*,\@local_*}
      '';

      sha256 = "0k31skb2ka0aks6xmggzd0v3pm8j1a6w8ywd6caqznkwha2r7g5x";
    };

    buildAttrs = {
      preBuild = ''
        patchShebangs .
        find -type f -name CROSSTOOL\* -exec sed -i \
          -e 's,/usr/bin/ar,${stdenv.cc.bintools}/bin/ar,g' \
          -e 's,/usr/bin/ld,${stdenv.cc.bintools}/bin/ld,g' \
          -e '/linker_flag: "-B\/usr\/bin\/"/d' \
          {} \;
      '';

      installPhase = ''
        sed -i 's,.*bdist_wheel.*,cp -rL . "$out"; exit 0,' bazel-bin/tensorflow/tools/pip_package/build_pip_package 
        bazel-bin/tensorflow/tools/pip_package/build_pip_package $PWD/dist
      '';
    };

    dontFixup = true;
  };

in buildPythonPackage rec {
  pname = "tensorflow";
  inherit version;
  name = "${pname}-${version}";

  src = pkg;

  installFlags = lib.optional (!withTensorboard) "--no-dependencies";

  postPatch = lib.optionalString (pythonAtLeast "3.4") ''
    sed -i '/enum34/d' setup.py
  '';

  propagatedBuildInputs = [ pythonPackages.gast pythonPackages.termcolor
			    pythonPackages.astor pythonPackages.numpy 
			    pythonPackages.tensorflow-tensorboard
			    pythonPackages.grpcio
			    pythonPackages.six pythonPackages.protobuf pythonPackages.absl-py ]
                 ++ lib.optional (!isPy3k) pythonPackages.mock
                 ++ lib.optionals (pythonOlder "3.4") [ pythonPackages.backports_weakref pythonPackages.enum34 ];

 

  # Actual tests are slow and impure.
  checkPhase = ''
    ${python.interpreter} -c "import tensorflow"
  '';

  meta = with stdenv.lib; {
    description = "Computation using data flow graphs for scalable machine learning";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ jyp abbradar ];
    platforms = platforms.linux;
    broken = !(xlaSupport -> cudaSupport);
  };

  passthru = {
    site-packages = "lib/${python.libPrefix}/site-packages/tensorflow";
  };

  postInstall = ''
    rm $out/bin/tensorboard
  '';
}
