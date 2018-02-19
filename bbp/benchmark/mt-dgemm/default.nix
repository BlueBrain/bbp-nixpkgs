{ stdenv
, fetchurl
, blas
, withCBLAS ? true
}:


stdenv.mkDerivation rec {
	name = "mt-dgemm-${version}";
	version = "160114";

	src = fetchurl {
		url = "http://portal.nersc.gov/project/m888/apex/mt-dgemm_${version}.tgz";
		sha256 = "04bcjw3if1fms321rpy3mxsnli0xmj5czz71xxamxa71j4yy30k3";
	};


	buildInputs = [ blas ];

	preConfigure = ''
		sed -i 's@cblas\.h@${blas.blas.cblas_header}@g' mt-dgemm.c
	'';

	buildPhase = ''
		cc -o mt-dgemm ${if withCBLAS then ''-DUSE_CBLAS=1 -I${blas}/include/${blas.blas.include_prefix} -l${blas.blas.cblas_libname}'' else ''''} -fopenmp -O3 mt-dgemm.c

       '';


	installPhase = ''
		mkdir -p $out/bin
		cp mt-dgemm $out/bin/
	'';

}
