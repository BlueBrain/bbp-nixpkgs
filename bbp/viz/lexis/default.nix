{ stdenv
, boost
, fetchgitExternal
, cmake
, zeroeq
, zerobuf 
}:

stdenv.mkDerivation rec {
  name = "lexis-1.1.0-2017";
  buildInputs = [ stdenv boost zeroeq zerobuf ];
  nativeBuildInputs = [ cmake zerobuf.python ];


  src = fetchgitExternal {
    url = "https://github.com/HBPVIS/Lexis.git";
    rev = "1d70690282408f5e8513d9e05c72851988822177";
    sha256 = "1s8fmk1amry5fswvfy8ansj22656f08rldkar4rs1cid57q4py2l";
  };
  
  enableParallelBuilding = true;

  propagatedBuildInputs = [ zeroeq zerobuf  ];
  
}



