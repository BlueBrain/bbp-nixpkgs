{ stdenv, boost, fetchgitExternal, cmake, servus, pkgconfig, leveldb, doxygen }:

stdenv.mkDerivation rec {
  name = "lunchbox";
  version = "1.15.0";
  buildInputs = [ stdenv boost pkgconfig servus cmake leveldb doxygen];

  src = fetchgitExternal{
    url = "https://github.com/Eyescale/Lunchbox.git";
    rev = "f05b9c67aa9879e012f4c221d8fd1c945a60afb1";
    sha256 = "16f4a225c0bk9dj76pq5mlsdr8nd2bjrw609cagilw9g050gj3qh";
  };
 
  patches = [ ./unique_ptr.patch ./string_header.patch ./string_inline.patch ];
 

  cmakeFlags = [ "-DCOMMON_DISABLE_WERROR=TRUE" ];


  propagatedBuildInputs = [ servus ];


  enableParallelBuilding = true;
  
}



