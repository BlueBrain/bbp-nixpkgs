{
 stdenv
, fetchgit
, boost
, cmake
, servus
, lunchbox
, keyv
, vmmlib
, pkgconfig
, hdf5-cpp
, highfive
, zlib
, mvdtool
, pythonPackages
, doxygen
, bbptestdata
}:

stdenv.mkDerivation rec {
    name = "brion-${version}";
    version = "3.0-dev201808";

    buildInputs = [ stdenv pkgconfig mvdtool boost pythonPackages.python
                    pythonPackages.numpy pythonPackages.lxml
                    pythonPackages.sphinx_1_3 cmake vmmlib servus
                    lunchbox keyv hdf5-cpp highfive zlib doxygen bbptestdata ];

    src = fetchgit {
        url = "https://github.com/BlueBrain/Brion.git";
        rev = "ae1efabfc1958931a07c1f5446b555f3c7463a2d";
        sha256 = "094nz68wpmyjf88qkpqnpd4whhx0yidrn5p7mjyb2cfxmbw6q8vw";
    };

    enableParallelBuilding = false; # memory consumption too high for python bindings generation

    cmakeFlags = [ "-DDISABLE_SUBPROJECTS=TRUE" ];

    makeFlags = [ "VERBOSE=1" ];

    propagatedBuildInputs = [ servus vmmlib boost
                              pythonPackages.python pythonPackages.numpy];

    passthru = {
        pythonModule = pythonPackages.python;
    };
}
