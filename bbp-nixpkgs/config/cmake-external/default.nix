{stdenv, git, cacert, curl}: 

## give to nix required environment to use the viz team
## cmake externals and subprojects

stdenv.mkDerivation {

  name= "cmake-external";
  
  buildInputs = [ stdenv curl];
  
  unpackPhase= '' echo "no source to unpack" '';
  
  dontBuild = true;
	
  CACERT_DIR = cacert;
  
  installPhase = ./install_hook.sh;
  
  propagatedBuildInputs = [ git cacert ]; 

  preferLocalBuild = true;


}
