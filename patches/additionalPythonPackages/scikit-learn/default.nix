{ stdenv, buildPythonPackage, fetchpatch, fetchurl, python
, nose, pillow
, gfortran, glibcLocales
, numpy, scipy
, blas
}:

buildPythonPackage rec {
  pname = "scikit-learn";
  version = "0.19.1";
  name = "${pname}-${version}";
  disabled = stdenv.isi686;  # https://github.com/scikit-learn/scikit-learn/issues/5534

  src = fetchurl {
        url = "mirror://pypi/s/scikit-learn/${name}.tar.gz";
        sha256 = "1813ncssfxcq5rfd9x5x0h1mwkhva2fxij02pbaf1aq4xqrav82w";
  };

  buildInputs = [ nose pillow gfortran glibcLocales ];
  propagatedBuildInputs = [ numpy scipy blas ];

  LC_ALL="en_US.UTF-8";

  checkPhase = ''
    # disable under 16.09
    #HOME=$TMPDIR OMP_NUM_THREADS=1 nosetests $out/${python.sitePackages}/sklearn/
  '';

  meta = with stdenv.lib; {
    description = "A set of python modules for machine learning and data mining";
    homepage = http://scikit-learn.org;
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
 

   passthru = {
	pythonDeps = propagatedBuildInputs;
  };
}


