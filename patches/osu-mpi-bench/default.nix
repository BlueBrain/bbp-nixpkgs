{ stdenv
, fetchurl
, mpi
}:


stdenv.mkDerivation rec {
    name = "osu-mpi-benchmark-${version}";
    version = "5.4.2";

    src = fetchurl {
        url  = "http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-${version}.tar.gz";
        sha256 = "d6da4d9a560f74fb5681f13b474e4e455e46b5df44dabd8b11dc45c27eaa28d1";
    };

    buildInputs = [ mpi ];
    

   preConfigure = ''
	export LDFLAGS="-lmpi"

   '';

   preBuild = ''
	cd mpi
   '';  
  
    
    installPhase = ''
	make install
        mkdir -p $out/bin
	
	for i in $(ls $out/libexec/osu-micro-benchmarks/mpi/*/*)
	do
		echo "binary $i"
		ln -s $i $out/bin/$(basename $i)
        done
    '';

    enableParallelBuilding = false;

}
