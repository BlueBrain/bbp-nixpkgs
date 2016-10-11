{ stdenv
, boost
, fetchgitExternal
, cmake
, zeroeq
, zerobuf 
}:

stdenv.mkDerivation rec {
  name = "lexis-1.12.0";
  buildInputs = [ stdenv boost zeroeq zerobuf ];
  nativeBuildInputs = [ cmake zerobuf.python ];


  src = fetchgitExternal {
    url = "https://github.com/HBPVIS/Lexis.git";
    rev = "c24dc078337d0c6f65ab057178bd7d9d655732ee";
    sha256 = "1qhi41an0b7vi5jl0fvaq7q5ivqgjnfgbh6d9xj8vq5v17hhqj8v";
  };
  
  enableParallelBuilding = true;

  propagatedBuildInputs = [ zeroeq zerobuf  ];
  
}



