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
, glibc_multi
}:


let 
        ispc-patch-dir= "${ispc.src}/llvm_patches";

        ispc-llvm-patches = [ 
                              "${ispc-patch-dir}/3_8_skx_patch_pack.patch"
                            ];

        llvm-ispc = llvm;

        ispc = clangStdenv.mkDerivation rec {
            name = "ipsc-${version}";
            version = "1.9.2";

            buildInputs = [ pkgconfig llvm-ispc ncurses zlib glibc_multi ];
		
			nativeBuildInputs = [ automake autoconf bison flex python which ];

            src = fetchFromGitHub  {
                    owner = "ispc";
                    repo = "ispc";
                    rev = "417b33ee4ab6ef7874ba125d390574c3facc48ee";
                    sha256 = "0zaw7mwvly1csbdcbz9j8ry89n0r1fag1m1f579l4mgg1x6ksqry";
            };

            configurePhase = ''
                    export LLVM_HOME=${llvm-ispc}
					export NIX_CFLAGS_COMPILE="-I ${clangUnwrapped}/include $NIX_CFLAGS_COMPILE";
					sed -i 's/^LLVM_VERSION=.*/LLVM_VERSION=LLVM_3_9/g' Makefile 
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
