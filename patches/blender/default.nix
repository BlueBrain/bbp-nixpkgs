{ stdenv
, fetchFromGitHub
, stdpkgs
, pythonPackages
, opencollada
, pythonModule ? false
}:


(stdpkgs.blender.overrideDerivation (oldAttr: rec {
	# prepare blender for next release 

    name = if (pythonModule) then "${oldAttr.name}-python" else oldAttr.name;
    origin_version = "2.79";
    version = "${origin_version}-nantille";


    src = fetchFromGitHub {
        owner = "nantille";
        repo = "blender_mod";
        rev = "5b1280da79528626a18ac04b3f585f0dce783f89";
        sha256 = "0jfklmc7i61y69rm3iz2vym1s2yf2q7v83zz2fawfg9hmyws1i17";
    };
    

    cmakeFlags = oldAttr.cmakeFlags ++ (stdenv.lib.optional (pythonModule) [ "-DWITH_PYTHON_MODULE=ON" "-DWITH_PLAYER=OFF" "-DWITH_PYTHON_INSTALL=OFF" ]);

    preInstall = ''
        mkdir -p $out/lib/${pythonPackages.python.libPrefix}/site-packages/${origin_version}/scripts
    '';


})).override {
    python = pythonPackages.python;
    opencollada = opencollada;

}
