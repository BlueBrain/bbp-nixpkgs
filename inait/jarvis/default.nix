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
      rev = "92aeea610a7fa81ba6cc846724cfb28517b8da57";
      sha256 = "0bzdww30n2b2jrdzbmfl8scc8jgfl6n45hlbgv7m4svma5x3wdcb";
    };
    
    jarvis_version = "1.12";

    pyjarvis = pythonPackages.buildPythonPackage rec {
      name = "pyjarvis-${version}";
      version = jarvis_version;

      src = jarvis_src;

      propagatedBuildInputs = [ pythonPackages.pyzmq4 ];
    
      doCheck = false;  
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


