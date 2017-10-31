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
    rev = "f84436c295fb0401e72f9b9f2370bbbbba2cc059";
    sha256 = "15z390z3pip43bhd2a0wmqcnzlqqhw857ghrxaf5i49xzhyy4qam";
  };
  
  enableParallelBuilding = false;

  propagatedBuildInputs = [ vmmlib zerobuf ];
  
}



