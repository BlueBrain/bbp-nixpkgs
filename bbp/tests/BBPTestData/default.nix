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
    rev = "5a14259bccca27529f6d9439808c09693bf4a095";
    sha256 = "03i4fih6ipq6zlawgxj1dbpxc7w112i2w8mv1g1299xlsjqdvrlp";
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




