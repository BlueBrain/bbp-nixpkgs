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

        ispc = stdenv.mkDerivation rec {
            name = "ipsc-${version}";
            version = "1.9.0";

            buildInputs = [ pkgconfig llvm-ispc ncurses zlib ];
		
			nativeBuildInputs = [ automake autoconf bison flex python which ];

            src = fetchFromGitHub  {
                    owner = "ispc";
                    repo = "ispc";
                    rev = "87d0c9a2ed7c9d0eb40303a040abba709280f1ac";
                    sha256 = "1wwsyvn44hd5iyi5779l5378x096307slpyl29wrsmfp66796693";
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
