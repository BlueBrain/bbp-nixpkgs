{ stdenv
, fetchgit
, glog
, google-gflags
, gtest
, opencv
, openblas
, protobuf
, pythonPackages
, cmake
, mpi ? null
, leveldb ? null
, lmdb ? null
, cuda ? null
}:


stdenv.mkDerivation rec {
    name = "caffe2-${version}";
    version = "0.8.0";

    src = fetchgit {
        url = "https://github.com/caffe2/caffe2.git";
        rev = "651e3debccaa1d4890ee6a7cb28e23d6bd5e481d";
        sha256 = "1mgpxzpjjlx269a3bm5919vazamlk74wyxxk6cippcyvlwda748h";
        
    };

    buildInputs = [ cmake protobuf openblas 
                    glog opencv google-gflags
                    pythonPackages.python pythonPackages.numpy 
                    gtest leveldb lmdb cuda
                    mpi ];

    cmakeFlags = [ 
                    ''-DUSE_NNPACK=OFF''
                    ''-DUSE_GLOO=OFF''
                    ''-DUSE_MPI=${if (mpi !=null) then ''ON''else ''OFF''}'' 
                    ''-DUSE_LEVELDB=${if (leveldb !=null) then ''ON''else ''OFF''}''
                    ''-DUSE_CUDA=${if (cuda !=null) then ''ON''else ''OFF''}''

                 ];

    postInstall = ''
        PYTHON_VERSION="${pythonPackages.python.libPrefix}"
        mkdir -p $out/lib/$PYTHON_VERSION/
        ln -s $out/ $out/lib/$PYTHON_VERSION/site-packages
    '';                
                    
    doCheck = true;

    checkPhase = ''
        export LD_LIBRARY_PATH="''${PWD}/caffe2:''${LD_LIBRARY_PATH}"
        export LD_LIBRARY_PATH="''${PWD}/third_party/googletest/googlemock/:''${LD_LIBRARY_PATH}"
        export LD_LIBRARY_PATH="''${PWD}/third_party/googletest/googlemock/gtest:''${LD_LIBRARY_PATH}"
        export LD_LIBRARY_PATH="''${PWD}/third_party/benchmark/src/:''${LD_LIBRARY_PATH}"
        ctest -V
    '';

    enableParallelBuilding = true;

}
