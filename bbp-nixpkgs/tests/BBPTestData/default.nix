{ stdenv, fetchgitPrivate, cmake, cmake-external, pkgconfig}:

stdenv.mkDerivation rec {
  name = "bbptestdata-2.0.0-DEV";
  buildInputs = [ stdenv cmake pkgconfig cmake-external];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/common/TestData";
    rev = "004a1f225404128798ac3e080aa3449f875bcc4b";
    sha256 = "0wlmxqr9zjrc1wnp49qmvn213p5f4j068ijpjw4133f5cj77g692";
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




