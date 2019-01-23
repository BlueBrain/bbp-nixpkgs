{ stdenv
, fetchgit
, stdpkgs
, pythonPackages
, opencollada
, pythonModule ? false
}:


(stdpkgs.blender.overrideDerivation (oldAttr: rec {

    name = "blender-2.80";

    origin_version = "2.80";
    version = "${origin_version}-nantille";

    src = fetchgit {
       url  = "https://github.com/ppodhajski/blender_28_mod";
       rev = "1feaab9cd6d44fd00f9736232d3c7e8770136558";
       sha256 = "18micpr8jj940zaw8w4z2dwyw7a4pzmg9533vgy91343x7ww28rk";
    };

    cmakeFlags = oldAttr.cmakeFlags ++ [ "-DSHARED_LIBRARY=ON" "-DWITH_PYTHON_MODULE=OFF" "-DWITH_PLAYER=OFF" "-DWITH_PYTHON_INSTALL=ON" "-DWITH_PYTHON_INSTALL_NUMPY=ON" "-DPYTHON_NUMPY_INCLUDE_DIRS=${pythonPackages.numpy}/lib/python3.6/site-packages/numpy/core/include" "-DPYTHON_NUMPY_PATH=${pythonPackages.numpy}/lib/python3.6/site-packages" ];

    buildInputs = oldAttr.buildInputs;

    preInstall = ''
        mkdir -p $out/lib/${pythonPackages.python.libPrefix}/site-packages/${origin_version}/scripts
    '';
    postInstall = ''
    cp -rf ./lib $out
    '';

})).override {
    python = pythonPackages.python;
    opencollada = opencollada;
}
