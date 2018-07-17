{ stdenv, 
fetchgit, 
mpiRuntime,
blas,
blasLibName ? "openblas",
liblapack,
liblapackLibName ? "lapack",
pkgconfig,
python,
withDebug ? true,
with64bits ? true
}:


let 
	optFlags = "-fPIC -g -O2 -ftree-vectorize";
    
in

stdenv.mkDerivation rec {
  name = "PETSc-${version}${if (with64bits) then "-64b" else "32b"}";
  version = "3.9";

  src = fetchgit {
    url = "https://bitbucket.org/petsc/petsc";
    rev = "v3.9.3";
    sha256 = "1bkrvxjmhqs6ssq998x23lw7dqq6fb8kn9k1bifikcmqzk0gx8kx";
  };


  preConfigure = ''
        # petsc python configure script want an existing HOME directory
        # we provide him a fake one
        export HOME=$(mktemp -d)

        # like petsc non-standard cflags system does anyway NOT work
        # force the usage of CFLAGS through nix variables 
        export NIX_CFLAGS_COMPILE=" ${optFlags} ''${NIX_CFLAGS_COMPILE} "
  '';

 

  configureOpts = [
                         "--with-fc=0"
                         "--with-shared-libraries=false"
                  ];


  configureFlags = configureOpts  
		   ++ [ "--with-mpi-dir=${mpiRuntime}" ]
		   ++ [  "--with-blas-lib=${blas}/lib/lib${blasLibName}.so" ]
		   ++ stdenv.lib.optional (liblapack != null) [	 "--with-lapack-lib=${liblapack}/lib/lib${liblapackLibName}.so" ]
		   ++ stdenv.lib.optional (with64bits) [ "--with-64-bit-indices" ]
       ++ stdenv.lib.optional (withDebug == false) [ "--with-debugging=0" ];


  nativeBuildInputs = [ pkgconfig python ];

  buildInputs = [ blas liblapack mpiRuntime];
   

  buildFlags = [ "V=1"  ];

  ## cross compilation for Super-computer environments
  ##
  crossAttrs = rec {
        ## FixPETSc cross compilation bullshit
        ##
        ## PETSC need three steps configure steps to be configured in crossCompiled environment
        ## 1- configure one on frontend to generate script
        ## 2- run this generated script
        ## 3- configure again on backend
        ##
        ## we fake this behavior by using an already generated script that we reconfigure manually

        reconfigure_script = if withDebug then ./reconfigure-arch-linux2-c-debug.py.in else ./reconfigure-arch-linux2-c.py.in;

        preConfigure = ''
                        export HOME=$(mktemp -d)

                        ## reconfigure script for cross compile
                        substitute ${reconfigure_script} reconfigure-arch-linux2-c-debug.py \
                        --replace "@mpi_path@" "${mpiRuntime.crossDrv}" \
                        --replace "@liblapack_path@" "${liblapack.crossDrv}" \
                        --replace "@liblapackLibName@" "${liblapackLibName}" \
                        --replace "@blas_path@" "${blas.crossDrv}" \
                        --replace "@blasLibName@" "${blasLibName}" \
						--replace "@python_interpreter@" "${python}/bin/python"

                        chmod a+x ./reconfigure-arch-linux2-c-debug.py
                       '';

        configureScript = "${python}/bin/python ./reconfigure-arch-linux2-c-debug.py";

        configureFlags = "";
                         

       dontSetConfigureCross = true;
  };


  # -j not supported by petsc
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
