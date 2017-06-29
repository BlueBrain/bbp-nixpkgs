{ stdenv
, fetchurl
, python
, bgq-openblas
}:


let
	blas_config = ''
		export LAPACK="${bgq-openblas.crossDrv}/lib/libopenblas.so"
		export BLAS="${bgq-openblas.crossDrv}/lib/libopenblas.so"
		export OPENBLAS="${bgq-openblas.crossDrv}/lib/libopenblas.so"
		export MKL=None
		export PTATLAS=None
		export ATLAS=None
		'';


in 
stdenv.mkDerivation rec {

    name = "numpy-${version}";
    version = "1.9.2";

    src = fetchurl {
      url = "mirror://sourceforge/numpy/${name}.tar.gz";
      sha256 = "0apgmsk9jlaphb2dp1zaxqzdxkf69h1y3iw2d1pcnkj31cmmypij";
    };




    preConfigure = ''
#      sed -i 's/-faltivec//' numpy/distutils/system_info.py
#      sed -i '0,/from numpy.distutils.core/s//import setuptools;from numpy.distutils.core/' setup.py
    '';




    buildPhase = ''
		runHook preBuild

		'' + blas_config + ''
		
    	        ${python}/bin/${python.executable} setup.py build

		runHook postBuild
		'';


     installPhase = ''

    runHook preInstall

    mkdir -p "$out/lib/${python.libPrefix}/site-packages"

    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

    ${python}/bin/${python.executable} setup.py install \
      --install-lib=$out/lib/${python.libPrefix}/site-packages \
      --prefix="$out" 

    '';


    nativeBuildInputs = [ python ];
    buildInputs = [ bgq-openblas ];
    propagatedBuildInputs = [ bgq-openblas ];

    meta = {
      description = "Scientific tools for Python";
      homepage = "http://numpy.scipy.org/";
    };


   crossAttrs = {

	buildPhase = '' 
                runHook preBuild

                '' + blas_config + ''

                ${python}/bin/${python.executable} setup.py build

                runHook postBuild
	'';


	
    preConfigure = ''
    '';




   };


}

