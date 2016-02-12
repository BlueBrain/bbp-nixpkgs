{stdenv, git, cacert}: 

## give to nix required environment to use the viz team
## cmake externals and subprojects

stdenv.mkDerivation {

  name= "cmake-external";
  
  unpackPhase= '' echo "no source to unpack" '';
  
  dontBuild = true;
  
  installPhase = ''
  mkdir -p $out/nix-support;
  echo "Configure environment for BBP viz team cmake externals" > $out/README
  echo "export GIT_SSL_CAINFO=\"${cacert}/etc/ssl/certs/ca-bundle.crt\"" >  $out/nix-support/setup-hook
  '';
  
  propagatedBuildInputs = [ git cacert ]; 

  #impureEnvVars = [
  # We borrow these environment variables from the caller to allow
  # easy proxy configuration.  This is impure, but a fixed-output
  # derivation like fetchurl is allowed to do so since its result is
  # by definition pure.
  # "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"
  # ];
    

}
