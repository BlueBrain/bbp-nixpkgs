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
    version = "latest";

    buildInputs = [ stdenv pkgconfig mvdtool boost pythonPackages.python
                    pythonPackages.numpy pythonPackages.lxml
                    pythonPackages.sphinx_1_3 cmake vmmlib servus
                    lunchbox keyv hdf5-cpp highfive zlib doxygen bbptestdata ];

    src = fetchgit {
        url = "https://github.com/BlueBrain/Brion.git";
        rev = "60809ca17cd128061a788272dd4ef411d2b17334";
        sha256 = "04rg49k6hr5qsqzw22af873haspgv9y70k660rsr7cll7ljnqhi0";
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
