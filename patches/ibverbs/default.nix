
{ stdenv, fetchurl, libnl }:

let

  verbs = rec {
      version = "1.2.1";
      name = "libibverbs-${version}";
      url = "http://downloads.openfabrics.org/verbs/${name}.tar.gz";
      sha256 = "0c63bb4bfcii5rrh633aa1qdfy0xf8dmv8zsfkm317cs9vrafln3";
 };

  drivers = {
      libmlx4 = rec { 
          version = "1.2.1";
          name = "libmlx4-${version}"; 
          url = "http://downloads.openfabrics.org/mlx4/${name}.tar.gz";
          sha256 = "07nq8x4fh8wjsk0f82s8a65f6p5gn41vi7lb6kr47x3rrc5lwq34";
      };
      libmlx5 = rec { 
          version = "1.2.1";
          name = "libmlx5-${version}"; 
          url = "http://downloads.openfabrics.org/mlx5/${name}.tar.gz";
          sha256 = "0qkcwa6has0z1gig6305vy4v8c0cajr3727q78yds9m7r501fmfh";
      };
      libmthca = rec { 
          version = "1.0.6"; 
          name = "libmthca-${version}"; 
          url = "http://downloads.openfabrics.org/mthca/${name}.tar.gz";
          sha256 = "0p45zjyy12afcair81424740j02ibcmyh11hslrq5mim244s73nc";
      };
  };

in stdenv.mkDerivation rec {

  inherit (verbs) name version ;

  srcs = [
    ( fetchurl { inherit (verbs) url sha256 ; } )
    ( fetchurl { inherit (drivers.libmlx4) url sha256 ; } )
    ( fetchurl { inherit (drivers.libmlx5) url sha256 ; } )
    ( fetchurl { inherit (drivers.libmthca) url sha256 ; } )
  ];

  configureFlags = "--without-resolve-neigh";

  sourceRoot = name;

  # Install userspace drivers
  postInstall = ''
    for dir in ${drivers.libmlx4.name} ${drivers.libmlx5.name} ${drivers.libmthca.name} ; do
      cd ../$dir
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$out/include"
      export NIX_LDFLAGS="-rpath $out/lib $NIX_LDFLAGS -L$out/lib"
      ./configure $configureFlags
      make -j$NIX_BUILD_CORES
      make install
    done
	rm -f $out/lib/*.la
  '';

  # Re-add the libibverbs path into runpath of the library
  # to enable plugins to be found by dlopen
  postFixup = ''
    RPATH=$(patchelf --print-rpath $out/lib/libibverbs.so)
    patchelf --set-rpath $RPATH:$out/lib $out/lib/libibverbs.so.1.0.0
  '';

  meta = with stdenv.lib; {
    homepage = https://www.openfabrics.org/;
    license = licenses.bsd2;
    platforms = with platforms; linux ++ freebsd;
    maintainers = with maintainers; [ wkennington bzizou ];
  };
}


