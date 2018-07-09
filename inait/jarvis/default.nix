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
      rev = "dd22ca219633fd29b48fdfe3c5f5d1e1bac1dcd7";
      sha256 = "17b57qh3b7bvbhav8h802ncaa1j50vqsnag9alq3wqvwdgznbq18";
    };
    
    jarvis_version = "2.0";

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


