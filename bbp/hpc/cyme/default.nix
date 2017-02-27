{ stdenv, fetchgitExternal, boost, cmake }:

stdenv.mkDerivation rec {
  name = "cyme-${version}";
  version = "1.5.0-2017";
  
  buildInputs = [ stdenv boost cmake ];

  src = fetchgitExternal {
    url = "https://github.com/BlueBrain/cyme.git";
    rev = "86c88a20cab80477ea34cfade6b534ba0298f8eb";
    sha256 = "01aghhyfgvsniqklw7rqmd2q13fcb5yrbvnavyh38jy7h1i1fwxk";
  }; 

  enableParallelBuilding = true;
  
    
  doCheck = true;
  
  checkTarget = "test";
  
}


