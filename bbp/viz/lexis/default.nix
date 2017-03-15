{ stdenv
, boost
, fetchgitExternal
, cmake
, zeroeq
, zerobuf 
, vmmlib
}:

stdenv.mkDerivation rec {
  name = "lexis-${version}";
  version = "1.1.0-2017.02";

  buildInputs = [ stdenv boost zeroeq zerobuf vmmlib ];
  nativeBuildInputs = [ cmake zerobuf.python ];


  src = fetchgitExternal {
    url = "https://github.com/HBPVIS/Lexis.git";
    rev = "0059c513e01ec9581b56f892a00ec4216c4ad5d2";
    sha256 = "1cc5bdcgkr01nzr7yyncp35gck4zgj74mn0fbinfxz0yisgaazl4";
  };
  
  enableParallelBuilding = true;

  propagatedBuildInputs = [ zeroeq zerobuf  ];
  
}



