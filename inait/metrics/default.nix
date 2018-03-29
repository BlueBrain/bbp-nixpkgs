{ stdenv
, config
, fetchgitPrivate
, pkgconfig
, pythonPackages
 }:

let
    metrics_src = fetchgitPrivate {
      url = config.inait_git_ssh + "/PIPELINE/metrics.git";
      rev = "b82195ba5b41a6033ac136e71b1e826ff54b4e92";
      sha256 = "1jykjifvmfsbr92md6cab9rhkd4wi92fn8g0k5bkgzckgyy6wqhp";
    };
    
    metrics_version = "0.2";

    client = pythonPackages.buildPythonPackage rec {
      name = "metrics-client-${version}";
      version = metrics_version;

      src = metrics_src;

      preConfigure = ''
        cd client
      '';

      propagatedBuildInputs = [ pythonPackages.pyjarvis pythonPackages.peewee ];
      
    };

    server = pythonPackages.buildPythonPackage rec {
      name = "metrics-server-${version}";
      version = metrics_version;

      src = metrics_src;

      preConfigure = ''
        cd client
      '';

      propagatedBuildInputs = [ pythonPackages.pyjarvis pythonPackages.peewee ];
      
    };
    
    
in {
    client = client; 
    server = server;
}


