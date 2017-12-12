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
        rev = "1684f5f05641ee10c6f53a6638465cb2ab134f87";
        sha256 = "1nrk3v8hj8z36xpsfi7i19qrjhdc8j3p6s8dmrh0irqvdvi5jxgq";
    };
    

    cmakeFlags = oldAttr.cmakeFlags ++ (stdenv.lib.optional (pythonModule) [ "-DWITH_PYTHON_MODULE=ON" "-DWITH_PLAYER=OFF" "-DWITH_PYTHON_INSTALL=OFF" ]);

    preInstall = ''
        mkdir -p $out/lib/${pythonPackages.python.libPrefix}/site-packages/${origin_version}/scripts
    '';


})).override {
    python = pythonPackages.python;
    opencollada = opencollada;

}
