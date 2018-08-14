{ stdenv
, config
, fetchgitExternal
, cmake
, pkgconfig }:

stdenv.mkDerivation rec {
  name = "bbptestdata-2.0.0-DEV";
  buildInputs = [ stdenv cmake pkgconfig];


  src = fetchgitExternal {
    url = config.bbp_git_ssh + "/common/TestData";
    rev = "8a0ff7b4101dd87e7095e1f9b65d9c8c9cfbf2cb";
    sha256 = "1zxykj87amv4kb9wsw5vxw9z9q4i7xj5fx1piighvwxgrnxx14qi";
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




