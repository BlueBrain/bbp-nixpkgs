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
gfortran ? null,
enforceLocalBuild ? false,
extraConfigureFlags ? []
 }:

stdenv.mkDerivation rec {
  name = "mvapich2-${version}";
  version = "2.2";

  src = fetchurl {
    url = "http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-${version}.tar.gz";
    sha256 = "0cdi7cxmkfl1zhi0czmzm0mvh98vbgq8nn9y1d1kprixnb16y6kr";
  };

  configureFlags = [ "--enable-shared" 
                    "--enable-sharedlibs=gcc"
                    "--enable-cxx"
					"--enable-g=dbg"
					"--enable-debuginfo"
                    "--enable-fast=O2"
                    "--with-munge"
                    "--disable-mcast"
                    "--enable-threads=multiple"
                    "--enable-smpcoll" ]
                    ++ ( if (gfortran != null) then [ "--enable-fortran" ] else [ "--disable-fc" "--disable-f77" "--disable-fortran" ])
                    ++  (if (enableXrc == true) then [ "--enable-xrc" ] else [ "--disable-xrc" ])
                    ++ (stdenv.lib.optional) (hwloc != null) ["--with-hwloc"]                    
                    ++ (stdenv.lib.optional) (slurm-llnl != null)  ["--with-slurm" "--with-slurm-include=${slurm-llnl}/include"
                          "--with-slurm-lib=${slurm-llnl}/lib" "--with-pm=none" "--with-pmi=slurm" ]
                    ++ (stdenv.lib.optional)  (libibverbs != null) [ "--with-ibverbs-include=${libibverbs}/include" "--with-ibverbs-lib=${libibverbs}/lib" ]
                    ++ (stdenv.lib.optional) (librdmacm != null) [ "--with-mpe" "--enable-rdma-cm" "--with-rdma=gen2"
                    "--with-ib-libpath=${librdmacm}/lib" "--with-ib-include=${librdmacm}/include" ] 
                    ++ extraConfigureFlags; 


  buildInputs = [ gfortran python perl pkgconfig slurm-llnl libibverbs librdmacm hwloc numactl ];
   
  propagatedBuildInputs = [slurm-llnl hwloc numactl librdmacm libibverbs ] 
        ++ stdenv.lib.optional (stdenv ? glibc) [ stdenv.glibc ] ;

  # unsafe build script, cannot be built in parallel
  enableParallelBuilding = false;


  preferLocalBuild = enforceLocalBuild;


  postInstall = ''

  # Pick C/C++ compilers available when using mpicc and mpicxx
  sed "s/^CC=.*/CC=cc/" -i $out/bin/mpicc
  sed "s/^CXX=.*/CXX=c++/" -i $out/bin/mpicxx

	## add pmi directly in the libmvapich2 path to avoid 
        ## modules incompatibilities
	${if (slurm-llnl!= null) then ''cp ${slurm-llnl}/lib/libpmi* $out/lib/'' else '' ''}


	rm -f $out/lib/*.la;
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
