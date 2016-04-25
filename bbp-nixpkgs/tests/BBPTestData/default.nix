{ stdenv, fetchgitPrivate, cmake, cmake-external, pkgconfig}:

stdenv.mkDerivation rec {
  name = "bbptestdata-2.0.0-DEV";
  buildInputs = [ stdenv cmake pkgconfig cmake-external];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/common/TestData";
    rev = "5a14259bccca27529f6d9439808c09693bf4a095";
    sha256 = "0rvyyv4pss4asvvbm3lprpx5hxp41hfdn0p7ykfmgdwc55xnikz6";
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
    cp -r ../local $out/share/bbptestdata/    &&
    install -D  installed/include/BBP/TestDatasets.h $out/include/BBP/TestDatasets.h 
    '';
    
}




