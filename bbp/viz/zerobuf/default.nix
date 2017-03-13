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
  version = "0.4-2017.02";

  buildInputs = [ stdenv pkgconfig servus cmake python-env boost ];


  src = fetchgitExternal{
    url = "https://github.com/HBPVIS/ZeroBuf.git";
    rev = "136330e10c1b1e3b8a8eae4843fbc95c7e00d498";
    sha256 = "0viy281k483nllvfp9q925xqr0c5ii8w8l9h3fpz62vhjr2j0yq2";
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



