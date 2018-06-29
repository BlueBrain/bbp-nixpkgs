{ stdenv, lib, fetchPypi, buildPythonPackage, isPy3k
, bleach_1_5_0
, bleach
, numpy
, werkzeug
, protobuf
, markdown
, futures
, html5lib_0_9999999
}:

# tensorflow is built from a downloaded wheel, because
# https://github.com/tensorflow/tensorboard/issues/719
# blocks buildBazelPackage.

buildPythonPackage rec {
  pname = "tensorflow-tensorboard";
  version = "1.8.0";
  name = "${pname}-${version}";
  format = "wheel";

  src = fetchPypi ({
    pname = "tensorboard";
    inherit version;
    format = "wheel";
  } // (if isPy3k then {
    python = "py3";
    sha256 = "0vm366znpzghp4rm8zxmjy6a7v5q380nrs790v8prl6hry5wqxkp";
  } else {
    python = "py2";
    sha256 = "09c7yrcigx9wibv9i7n76ww2fppj9dp5f51m5k5r6r8s4vcs8l96";
  }));

  propagatedBuildInputs = [ numpy werkzeug protobuf markdown bleach_1_5_0 ] 
			   ++ lib.optionals (!isPy3k) [ futures ] ;

  meta = with stdenv.lib; {
    description = "TensorFlow's Visualization Toolkit";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
