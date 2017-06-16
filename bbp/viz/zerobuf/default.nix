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
  version = "0.5-2017.06";

  buildInputs = [ stdenv pkgconfig servus cmake python-env boost ];


  src = fetchgit {
    url = "https://github.com/HBPVIS/ZeroBuf.git";
    rev = "85e8d86";
    sha256 = "1w95584smfgg926yklgjrpm3xlc7fblj910a0ddszqj94vb366k3";
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



