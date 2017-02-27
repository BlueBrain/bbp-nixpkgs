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
  version = "0.4-2017";

  buildInputs = [ stdenv pkgconfig servus cmake python-env boost ];


  src = fetchgitExternal{
    url = "https://github.com/HBPVIS/ZeroBuf.git";
    rev = "f40a6e46fae17aa54f54f65047a227b37843c993";
    sha256 = "06m1khj0pgl5ndfij8lfnk4nfncxppp5ns68ws68caaz5pf0zh4s";
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



