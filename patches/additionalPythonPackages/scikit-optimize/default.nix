{ stdenv, buildPythonPackage, fetchpatch, fetchurl, python
, nose, pillow
, gfortran, glibcLocales
, numpy, scipy, matplotlib
, scikit-learn
}:

buildPythonPackage rec {
  pname = "scikit-optimize";
  version = "0.5";
  name = "${pname}-${version}";

  src = fetchurl {
        url = "mirror://pypi/s/scikit-optimize/${name}.tar.gz";
        sha256 = "04kpvn7k7qiv2nzpszgnszaxi2hr1dw66s27z311d3k9cbhrl3y2";
  };

  buildInputs = [ nose pillow gfortran glibcLocales ];
  propagatedBuildInputs = [ numpy scipy scikit-learn matplotlib ];

  LC_ALL="en_US.UTF-8";

}


