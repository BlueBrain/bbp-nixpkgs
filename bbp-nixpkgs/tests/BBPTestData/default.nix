{ stdenv, fetchgitPrivate, cmake, bbp-cmake, pkgconfig}:

stdenv.mkDerivation rec {
  name = "bbptestdata-2.0.0-DEV";
  buildInputs = [ stdenv cmake bbp-cmake pkgconfig ];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/common/TestData";
    rev = "6371cdf4cbc2c6f8830c7fa5312e5eb3794e1f21";
    sha256 = "1pqi9j1f3m6017i3pyr7rmml8hqip04ai0prsdw82mmhk951m0iz";
  };
  
  patchPhase = ''
    ln -s ${bbp-cmake}/share/bbp-cmake/Common CMake/common && 
    sed -i 's@set(BBP_TESTDATA ''${PROJECT_SOURCE_DIR})@set(BBP_TESTDATA '$out'/share/bbptestdata/)@g' CMakeLists.txt
    '';  
  
  postInstall = ''
    mkdir -p $out/share/bbptestdata/ &&
    cp -r ../circuitBuilding_1000neurons $out/share/bbptestdata/ && 
    cp -r ../ballAndStick $out/share/bbptestdata/ && 
    cp -r ../NESTSpikeData $out/share/bbptestdata/ && 
    cp -r ../neuronMeshTest $out/share/bbptestdata/
    '';
    
}




