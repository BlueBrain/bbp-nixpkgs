{
    cmake,
    config,
    fetchgitPrivate,
    hdf5,
    python,
    pythonPackages,
    stdenv
}:

stdenv.mkDerivation rec {
    pname = "libsonata";
    version = "0.0.1";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/common/libsonata";
        rev = "6d1d1efc18b52068df60414b599cc25897ffc118";
        sha256 = "0p7nxqqb3l5cc81wmj96lm9avc0icbdcp7z31jnyfx4png23f3f9";
    };

    buildInputs = [
        cmake
        hdf5
        python
        stdenv
    ];

    propagatedBuildInputs = [
        pythonPackages.numpy
    ];

    cmakeFlags= [
        "-DCMAKE_BUILD_TYPE=Release"
        "-DSONATA_PYTHON=ON"
        "-DEXTLIB_FROM_SUBMODULES=ON"
        "-DPYTHON_EXECUTABLE=${python.interpreter}"
        "-DPYTHON_INSTALL_SUFFIX=${python.sitePackages}"
    ];

    enableParallelBuilding = true;

    doCheck = false;
    checkPhase = ''
        ctest --output-on-failure
    '';
}
