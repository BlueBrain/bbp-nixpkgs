{ stdenv, 
fetchgit, 
mpiRuntime,
openblas,
liblapack,
pkgconfig,
python 
}:

stdenv.mkDerivation rec {
  name = "PETSc-${version}";
  version = "3.7";

  src = fetchgit {
    url = "https://bitbucket.org/petsc/petsc";
    rev = "2c0821f3de96fea3e6a1a9ad8163ac8c8ba17bb0";
    sha256 = "19lgnscnf3pwnya82l5alf4ma039d58crv02pjjw83mx3pwkhnxd";
  };


  preConfigure = ''
	# petsc python configure script want a HOME
        # we provide him a tmp one
	export HOME=$(mktemp -d)
  '';

  configureFlags = [
			 "--with-mpi-dir=${mpiRuntime}"
			 "--with-fc=0"
			 "--with-blas-lib=${openblas}/lib/libopenblas.so"
			 "--with-lapack-lib=${liblapack}/lib/liblapack.so"

		   ];

  buildInputs = [ pkgconfig python openblas liblapack];
   


  # -j not supported by petsc
  # the option need to be manual with 
  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    description = "Portable, Extensible Toolkit for Scientific Computation";

    longDescription = ''
    PETSc, pronounced PET-see (the S is silent), is a suite of data structures and routines for the scalable (parallel) solution of scientific applications modeled by partial differential equations. It supports MPI, and GPUs through CUDA or OpenCL, as well as hybrid MPI-GPU parallelism.  
	'';

    homepage = https://www.mcs.anl.gov/petsc/index.html;
    license = licenses.bsd2;
    platforms = platforms.unix; 
  };
}
