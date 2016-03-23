{ stdenv, 
fetchurl, 
python, 
perl, 
pkgconfig,
slurm ? null,
libibverbs ? null,
rdmaCM ? true,
debugInfo ? true,
extraConfigureFlags ? "" }:

stdenv.mkDerivation {
  name = "mvapich2-2.1";

  src = fetchurl {
    url = "http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.1.tar.gz";
    sha256 = "0bvvk4n9g4rmrncrgs9jnkcfh142i65wli5qp1akn9kwab1q80z6";
  };

  configureFlags = "${if slurm != null then "--with-slurm --with-slurm-include=${slurm}/include 
                    --with-slurm-lib=${slurm}/lib --with-pm=none --with-pmi=slurm" else ""}
                    --enable-shared --enable-sharedlibs=gcc 
                    --disable-fc --disable-f77 --disable-fortran
                    --enable-cxx --enable-threads=multiple --with-munge
                    --enable-fast --enable-smpcoll --with-hwloc --enable-xrc                    
                    ${if debugInfo then "--enable-g=dbg --enable-debuginfo" else ""}
                    ${if rdmaCM then "--with-mpe --enable-rdma-cm --with-rdma=gen2" else ""}
                    ${if libibverbs != null then "--with-ib-include=${libibverbs}/include" else ""}
                    ${if libibverbs != null then "--with-ib-libpath=${libibverbs}/lib" else ""}                    
                    ${extraConfigureFlags}
                    "; 

  buildInputs = [ python perl pkgconfig]
   ++ stdenv.lib.optional (slurm != null) slurm
   ++ stdenv.lib.optional (libibverbs != null) libibverbs;
   
  propagatedBuildInputs = [] 
        ++ stdenv.lib.optional (stdenv ? glibc) stdenv.glibc
        ++ stdenv.lib.optional (slurm != null) slurm;

  # unsafe build script, cannot be built in parallel
  enableParallelBuilding = false;

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
