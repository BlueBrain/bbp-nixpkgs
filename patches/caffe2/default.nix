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
        rev = "b410c51831dc9a00d2e42137f728c7fd39fbf440";
        sha256 = "0n5ihcbgbj5l949fwm144riqx2hmzpzb5ydiil2r4z9j2frprf01";
        
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
        ln -s $out/python $out/lib/$PYTHON_VERSION/site-packages
    '';                
                    
    doCheck = true;

    checkPhase = ''
        ctest -V

    '';

}
