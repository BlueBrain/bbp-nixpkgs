{ stdenv, fetchgitExternal, cmake, servus, pkgconfig, python, pythonPackages, boost }:


let 
	python-env = python.buildEnv.override {
    extraLibs = [ 
				  pythonPackages.pyparsing
				];
 };

in
stdenv.mkDerivation rec {
  name = "zerobuf-${version}";
  version = "0.3.0-2016-09";

  buildInputs = [ stdenv pkgconfig servus cmake python-env boost ];


  src = fetchgitExternal{
    url = "https://github.com/HBPVIS/ZeroBuf.git";
    rev = "346c1b5a355542ed084600460b96f67f347797e9";
    sha256 = "0immzcfzhvx2mxrblsh4892qcl1alqx5qpyrz1r6xqcki6yh92yl";
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



