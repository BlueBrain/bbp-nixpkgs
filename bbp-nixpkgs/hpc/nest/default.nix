{ stdenv
, fetchFromGitHub
, pkgconfig
, boost
, cython
, cmake
, libtool
, gsl
, mpiRuntime
, python
, readline
}:

stdenv.mkDerivation rec {
  name = "nest-2.10.0";
  buildInputs = [ stdenv cmake cython gsl libtool pkgconfig readline mpiRuntime python ];

  src = fetchFromGitHub {
    owner = "nest";
    repo = "nest-simulator";  
    rev = "193594f9ce199a0db1322e7752da00237a671f4b";
    sha256 = "09w9mkdi6jlac020i4icvxnxwnbh33mwfnldm9il2fl3xd4gza14";
  };
  


  enableParallelBuilding = true;
 
  outputs = [ "out" "doc" ];
  
}


