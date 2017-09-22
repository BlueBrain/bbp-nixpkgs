{ stdenv
, boost
, fetchgit
, cmake
, zeroeq
, zerobuf 
, vmmlib
}:

stdenv.mkDerivation rec {
  name = "lexis-${version}";
  version = "1.2.0-2017.06";

  buildInputs = [ stdenv boost zeroeq zerobuf vmmlib ];
  nativeBuildInputs = [ cmake zerobuf.python ];


  src = fetchgit {
    url = "https://github.com/HBPVIS/Lexis.git";
    rev = "a4e458a";
    sha256 = "1d5dpmzmnxg6pxin48sv05wgq09ap3ibmmy4g7ikgdjn0qab36hj";
  };
  
  enableParallelBuilding = true;

  propagatedBuildInputs = [ vmmlib zerobuf ];
  
}



