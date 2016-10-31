{ stdenv
, fetchurl
, blas ? null
, blasLibName ? "openblas"
}:


stdenv.mkDerivation rec {
  name = "clapack-${version}";
  version = "0.3.1";  
  
  src = fetchurl {
	url = "http://www.netlib.org/clapack/clapack.tgz";
	sha256 = "1b2z8mg1vi6l5d3dp9pd0v234hnjdb1srllgxnmcivjb2s1c7i3d";
  };

  buildInputs = [ blas ];

  configurePhase = ''
			substitute make.inc.example make.inc \
			${if (blas != null) then ''--replace "BLASLIB      = ../../blas$(PLAT).a" "BLASLIB       = ../../libcblaswr.a -L${blas}/lib -l${blasLibName}"'' else '' ''} \
			--replace "CC        = gcc" "CC        = $CC"
		   '';

  buildPhase = ''
		## build f2c
		make f2clib
		# build CBLAS wrapper if blas provided or build CBLAS
		${if (blas == null) then ''make blaslib'' else ''make cblaswrap'' }
		# build main lib
		make lapacklib

		# merge f2c and lapack
		mkdir -p liblapack
		pushd liblapack
		ar -x ../lapack_LINUX.a
		ar -x ../F2CLIBS/libf2c.a
		${if (blas == null) then ''ar -x ../blas_LINUX.a'' else ''ar -x ../libcblaswr.a''}
		ar -qc liblapack.a *.o
		popd 
		'';
 
  installPhase = ''
		install -D ./lapack_LINUX.a $out/lib/liblapack.a
		install -D ./F2CLIBS/libf2c.a $out/lib/libf2c.a
		${if (blas == null) then 
		''install -D ./blas_LINUX.a $out/lib/libblas.a''
		else
		''install -D ./libcblaswr.a  $out/lib/libcblaswr.a''}
		# install merged archive 
		install -D ./liblapack/liblapack.a $out/lib/liblapack_merged.a
		'';

  doCheck = true;

  checkTarget = [ "lapack_testing" ];
 
  crossAttrs = rec {

	dontSetConfigureCross = true;

	configurePhase =   ''
                        substitute make.inc.example make.inc \
                        ${if (blas != null) then ''--replace "BLASLIB      = ../../blas$(PLAT).a" "BLASLIB       = ../../libcblaswr.a -L${blas.crossDrv}/lib -l${blasLibName}"'' else '' ''} \
            		--replace "CC        = gcc" "CC        = $CC"
                   '';

	doCheck= false;

  };

}


