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
	  rev = "54021941b04e149364e29bd45bc2525cad62cb35";
	  sha256 = "0qkssx29rcs8h3is5jcswa1cs91aff9qsaylpjgwacrvg7xlvc0l";
	};
	
	jarvis_version = "1.1";

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
	
	};
	
in {
	pyjarvis = pyjarvis;
	server = server;
}


