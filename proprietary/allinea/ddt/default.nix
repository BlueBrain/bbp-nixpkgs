{ stdenv
, config
, xorg
, zlib
, freetype
, fontconfig
, expat
, libICE
, libSM
, libuuid
, libpng12
, ncurses
, patchelf_rewire
}:

assert (config ? allinea_ddt);


stdenv.mkDerivation rec {
	name = "allinea-ddt-${version}";
	version = "5.0.1";

	inherit stdenv;

    allina_ddt = config.allinea_ddt;

    nativeBuildInputs = [ patchelf_rewire ];


	buildCommand = ''
        set +e 
		## map cray mpich into nix store
		mkdir -p $out/

        cp -r ${allina_ddt}/* $out/

        export NIX_PATCHELF_LIB_RPATH="$out/lib"
        export NIX_PATCHELF_LIB_RPATH="$NIX_PATCHELF_LIB_RPATH:${xorg.libX11}/lib:${xorg.libXpm}/lib:${xorg.libXext}/lib"
        export NIX_PATCHELF_LIB_RPATH="$NIX_PATCHELF_LIB_RPATH:${stdenv.cc.cc}/lib"
        export NIX_PATCHELF_LIB_RPATH="$NIX_PATCHELF_LIB_RPATH:${zlib}/lib"
        export NIX_PATCHELF_LIB_RPATH="$NIX_PATCHELF_LIB_RPATH:${freetype}/lib"
        export NIX_PATCHELF_LIB_RPATH="$NIX_PATCHELF_LIB_RPATH:${fontconfig}/lib"
        export NIX_PATCHELF_LIB_RPATH="$NIX_PATCHELF_LIB_RPATH:${xorg.libXrender}/lib"
        export NIX_PATCHELF_LIB_RPATH="$NIX_PATCHELF_LIB_RPATH:${libICE}/lib"
        export NIX_PATCHELF_LIB_RPATH="$NIX_PATCHELF_LIB_RPATH:${libSM}/lib"
        export NIX_PATCHELF_LIB_RPATH="$NIX_PATCHELF_LIB_RPATH:${expat}/lib"
        export NIX_PATCHELF_LIB_RPATH="$NIX_PATCHELF_LIB_RPATH:${libuuid}/lib"
        export NIX_PATCHELF_LIB_RPATH="$NIX_PATCHELF_LIB_RPATH:${libpng12}/lib"
        export NIX_PATCHELF_LIB_RPATH="$NIX_PATCHELF_LIB_RPATH:${ncurses}/lib"

        find $out/libexec/ -maxdepth 1 -type f |  xargs -n 1 patchelf_rewire

        find $out/lib/ -type f | xargs -n 1 patchelf_rewire

        find $out/bin/ -type f | grep -v "sh$" | xargs -n 1 patchelf_rewire

        ## hack for tinfo on Nix
        ln -s ${ncurses}/lib/libncursesw.so.5 $out/lib/libtinfo.so.5

        exit 0 
	'';

}


