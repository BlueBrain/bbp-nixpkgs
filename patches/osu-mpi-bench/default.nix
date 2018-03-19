{ stdenv
, fetchurl
, mpi
}:


stdenv.mkDerivation rec {
    name = "osu-mpi-benchmark-${version}";
    version = "5.3.2";

    src = fetchurl {
        url  = "http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-${version}.tar.gz";
        sha256 = "0h3k95rwd78cq463xii9a3qxf1qxd1bz4r6lr9n08lql52r3zb5h";
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
