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
      rev = "b111e88097fa01245f26d94ad7febd714c74de13";
      sha256 = "04qgn3p4b7z0gzyq9wbprhr03c0y01qlzf388pakkdv3wq8zmi33";
    };
    
    jarvis_version = "1.11";

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


