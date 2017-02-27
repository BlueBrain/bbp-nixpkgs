{ stdenv
, fetchurl
, python
, bgq-openblas
}:

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

		export BLAS=None
		export LAPACK=None
		export ATLAS=None 

                ${python}/bin/${python.executable} setup.py build

                runHook postBuild
	'';


	
    preConfigure = ''
    '';




   };


}

