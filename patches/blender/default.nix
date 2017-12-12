{ stdenv
, fetchurl
, stdpkgs
, opencollada
, pythonModule ? false
}:


(stdpkgs.blender.overrideDerivation (oldAttr: rec {
	# prepare blender for next release 

    name = if (pythonModule) then "${oldAttr.name}-python" else oldAttr.name;
    version = "2.79";

    cmakeFlags = oldAttr.cmakeFlags ++ (stdenv.lib.optional (pythonModule) [ "-DWITH_PYTHON_MODULE=ON" "-DWITH_PLAYER=OFF" "-DWITH_PYTHON_INSTALL=OFF" ]);

    preInstall = ''
        mkdir -p $out/lib/python3.4/site-packages/2.75/scripts
    '';


})).override {

    opencollada = opencollada;

}
