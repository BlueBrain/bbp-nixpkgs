{ stdenv, fetchgit, cmake, servus, pkgconfig, python, pythonPackages, boost }:


let
	python-env = python.buildEnv.override {
    extraLibs = [
				  pythonPackages.pyparsing
				];
 };

in
stdenv.mkDerivation rec {
  name = "zerobuf-${version}";
  version = "0.5-dev201708";

  buildInputs = [ stdenv pkgconfig servus cmake python-env boost ];


  src = fetchgit {
    url = "https://github.com/HBPVIS/ZeroBuf.git";
    rev = "96e793d90343d125e59205aadfa6e767050cef5a";
    sha256 = "1dgsq080nqnpjq9qmb2ml5m2li9325gm03lh976ikmphd9vs0hdn";
  };

  enableParallelBuilding = false;

  propagatedBuildInputs = [ servus ];

  postInstall = ''
		sed -i 's@!/usr/bin/env python@!${python-env}/bin/python@g' $out/bin/zerobufCxx.py
		chmod a+x $out/bin/zerobufCxx.py
  '';

  doCheck = true;

  checkPhase = ''
		export LD_LIBRARY_PATH=''${PWD}/lib:''${LD_LIBRARY_PATH}
		ctest -V
		'';

  passthru.python = python-env;

}



