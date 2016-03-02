{ stdenv, fetchgitPrivate, cmake, cmake-external, pkgconfig}:

stdenv.mkDerivation rec {
  name = "bbptestdata-2.0.0-DEV";
  buildInputs = [ stdenv cmake pkgconfig cmake-external];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/common/TestData";
    rev = "1fac183b84678ccc71503697b9a9d4e7c0bba9b0";
    sha256 = "161aaljhmkfffj4m752xn7db2nyaxilqjs2pns2yvjfqpm6p8krm";
    leaveDotGit = true;
  };
  
  patchPhase = ''
    sed -i 's@set(BBP_TESTDATA ''${PROJECT_SOURCE_DIR})@set(BBP_TESTDATA '$out'/share/bbptestdata/)@g' CMakeLists.txt
    '';  
  
  postInstall = ''
    mkdir -p $out/share/bbptestdata/ &&
    cp -r ../circuitBuilding_1000neurons $out/share/bbptestdata/ && 
    cp -r ../ballAndStick $out/share/bbptestdata/ && 
    cp -r ../NESTSpikeData $out/share/bbptestdata/ && 
    cp -r ../neuronMeshTest $out/share/bbptestdata/ &&
    cp -r ../local $out/share/bbptestdata/    
    '';
    
}




