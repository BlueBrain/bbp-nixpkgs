{ stdenv
, clangStdenv
, clangUnwrapped
, llvm
, pkgconfig
, fetchFromGitHub
, fetchurl
, ncurses
, zlib
, which
, python
, automake
, autoconf
, bison
, flex
}:


let 
        ispc-patch-dir= "${ispc.src}/llvm_patches";

        ispc-llvm-patches = [ 
                              "${ispc-patch-dir}/3_8_skx_patch_pack.patch"
                            ];

        llvm-ispc = llvm;

        ispc = clangStdenv.mkDerivation rec {
            name = "ipsc-${version}";
            version = "1.9.1-dev-201703";

            buildInputs = [ pkgconfig llvm-ispc ncurses zlib ];
		
			nativeBuildInputs = [ automake autoconf bison flex python which ];

            src = fetchFromGitHub  {
                    owner = "ispc";
                    repo = "ispc";
                    rev = "a618ad45bf6a83e0f4a82378c62b5621c6719983";
                    sha256 = "1k7j8x8p5ks1dxdidk24mkyh3p6bfjv7nsnz0crq0sxn0szi6xbn";
            };

            configurePhase = ''
                    export LLVM_HOME=${llvm-ispc}
					export NIX_CFLAGS_COMPILE="-I ${clangUnwrapped}/include $NIX_CFLAGS_COMPILE";
					sed -i 's/^LLVM_VERSION=.*/LLVM_VERSION=LLVM_3_6/g' Makefile 
					sed -i 's/\-lcurses//g' Makefile 
            '';

			buildFlags = [ "ispc" "V=1" ];

		    installPhase = ''
							install -D ./ispc $out/bin/ispc 
							install -D ./LICENSE.txt $out/share/${name}/LICENSE
			'';
		
            passthru.src = src;
        };

in 
        ispc
