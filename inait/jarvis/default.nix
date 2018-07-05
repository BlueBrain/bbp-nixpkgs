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
      rev = "e4934121a1038996c3b987dce661dc7c925bc3a6";
      sha256 = "1g5xhfj3dqxad7p5khgbiqipjyv7gh3sxx5f9qsgxqm7kjpfh0mb";
    };
    
    jarvis_version = "1.13";

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


