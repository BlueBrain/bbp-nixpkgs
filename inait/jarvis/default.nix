{ stdenv
, config
, fetchgitPrivate
, pkgconfig
, boost
, cmake
, zeromq
, cppzmq
, pythonPackages
 }:

let
	jarvis_src = fetchgitPrivate {
	  url = config.inait_git_ssh + "/INFRA/Jarvis.git";
	  rev = "f5f764cbcaae3c1ea4401cde3766afa2a390cdb5";
	  sha256 = "0mhcr7r1lclmcxkih7xc30dafr5gyafp6aij53a9jlk9v0b57bwg";
	};
	
	jarvis_version = "0.6-dev";

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
		
	  buildInputs = [ cmake boost pkgconfig zeromq cppzmq ];

	  postInstall = ''
		mkdir -p $out/share/jarvis/config
		cp ../config/jarvis_inait.toml $out/share/jarvis/config
	  '';
	
	};
	
in {
	pyjarvis = pyjarvis;
	server = server;
}


