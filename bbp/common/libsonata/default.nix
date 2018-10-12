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
    version = "0.0.0";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/common/libsonata";
        rev = "5c02ec2f931cf0a15bfa3b70f113d8cece86495f";
        sha256 = "13g73lngxb1crkxzsqcvpi9na34yss1qwk4wk3qk38wy6lffkmmb";
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
        "-DSONATA_PYTHON=1"
        "-DPYTHON_EXECUTABLE=${python.interpreter}"
        "-DPYTHON_INSTALL_SUFFIX=${python.sitePackages}"
    ];

    enableParallelBuilding = true;

    doCheck = true;
    checkPhase = ''
        ctest --output-on-failure
    '';
}
