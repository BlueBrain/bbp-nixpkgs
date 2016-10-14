{ stdenv, 
fetchurl, 
python, 
perl, 
pkgconfig,
numactl ? null,
hwloc ? null,
slurm-llnl ? null,
libibverbs ? null,
librdmacm ? null,
enableXrc ? false,
debugInfo ? true,
extraConfigureFlags ? [] }:

stdenv.mkDerivation rec {
  name = "mvapich2-${version}";
  version = "2.2rc1";

  src = fetchurl {
    url = "http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-${version}.tar.gz";
    sha256 = "1rp93aw9f3bf40hq36kks0r3474smyvpmm073q6hv0bgmij4cqs8";
  };

  configureFlags = [ "--enable-shared" 
                    "--enable-sharedlibs=gcc"
                    "--disable-fc" "--disable-f77" "--disable-fortran"
                    "--enable-cxx" 
                    "--with-munge"
                    "--enable-fast"
                    "--disable-mcast"
                    "--enable-threads=multiple"
                    "--enable-smpcoll" ]
                    ++  (if (enableXrc == true) then [ "--enable-xrc" ] else [ "--disable-xrc" ])
                    ++ (stdenv.lib.optional) (hwloc != null) ["--with-hwloc"]                    
                    ++ (stdenv.lib.optional) (slurm-llnl != null)  ["--with-slurm" "--with-slurm-include=${slurm-llnl}/include"
                          "--with-slurm-lib=${slurm-llnl}/lib" "--with-pm=none" "--with-pmi=slurm" ]
                    ++ (stdenv.lib.optional)  (libibverbs != null) [ "--with-ibverbs-include=${libibverbs}/include" "--with-ibverbs-lib=${libibverbs}/lib" ]
                    ++ (stdenv.lib.optional)  (debugInfo != null) [ "--enable-g=dbg" "--enable-debuginfo"]
                    ++ (stdenv.lib.optional) (librdmacm != null) [ "--with-mpe" "--enable-rdma-cm" "--with-rdma=gen2"
                          "--with-ib-libpath=${librdmacm}/lib" "--with-ib-include=${librdmacm}/include" ]                  
                    ++ extraConfigureFlags; 


  buildInputs = [ python perl pkgconfig slurm-llnl libibverbs librdmacm hwloc numactl ];
   
  propagatedBuildInputs = [slurm-llnl hwloc numactl librdmacm libibverbs ] 
        ++ stdenv.lib.optional (stdenv ? glibc) [ stdenv.glibc ] ;

  # unsafe build script, cannot be built in parallel
  enableParallelBuilding = false;


  postInstall = ''
	## add pmi directly in the libmvapich2 path to avoid 
        ## modules incompatibilities
	${if (slurm-llnl!= null) then ''cp ${slurm-llnl}/lib/libpmi* $out/lib/'' else '' ''}
	'';

  meta = with stdenv.lib; {
    description = "Implementation of the Message Passing Interface (MPI) standard";

    longDescription = ''
        This is an MPI-2 implementation which includes all MPI-1 features.  It is
        based on MPICH and MVICH.

    '';
    homepage = http://mvapich.cse.ohio-state.edu/news/;
    license = licenses.bsd2;
    platforms = platforms.unix; 
  };
}
