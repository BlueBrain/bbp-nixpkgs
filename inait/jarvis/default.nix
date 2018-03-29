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
      rev = "618c1258711dcf9c36612d11f1ac9a67629a6e9c";
      sha256 = "1dfvliiz2fcxw5k2i8mia3k6h0jly1ywh9g92qq6bi2l4fcl31fs";
    };
    
    jarvis_version = "1.7";

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


