{ stdenv
, config
, fetchgitPrivate
, pkgconfig
, boost
, cmake
, zeromq
, rocksdb
, cppzmq
, pythonPackages
 }:

let
	jarvis_src = fetchgitPrivate {
	  url = config.inait_git_ssh + "/INFRA/Jarvis.git";
	  rev = "7eafd48ab6bff4cb87725594e45e4922057b28a4";
	  sha256 = "1d3r33w4l8h9ngsr3dz9gw2b1d0c5hbfp2lj2f3czmvdl9qw4pl5";
	};
	
	jarvis_version = "1.3";

	pyjarvis = pythonPackages.buildPythonPackage rec {
	  name = "pyjarvis-${version}";
	  version = jarvis_version;

	  src = jarvis_src;

	  propagatedBuildInputs = [ pythonPackages.pyzmq4 ];
	  
	};
	
	server = stdenv.mkDerivation rec {
	  name = "jarvis-${version}";
	  version = jarvis_version;
		
	  src = jarvis_src;
		
	  buildInputs = [ cmake boost rocksdb pkgconfig zeromq cppzmq ];

	  postInstall = ''
		mkdir -p $out/share/jarvis/config
		cp ../config/jarvis_inait.toml $out/share/jarvis/config
	  '';

	 doCheck = true;
         checkPhase = '' ctest -V ''; 
	
	};
	
in {
	pyjarvis = pyjarvis;
	server = server;
}


