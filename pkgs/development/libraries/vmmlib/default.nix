{ stdenv, fetchgit, cmake, doxygen  }:

stdenv.mkDerivation rec {
  name = "vmmlib-1.6.2";
  buildInputs = [ stdenv cmake doxygen ];

  src = fetchgit {
    url = "https://github.com/VMML/vmmlib.git";
    rev= "8c15735d2f0de56472f2bbd88f3c374c7b5e803d";
    sha256 = "0cwvbwav4ijp8n6x9rkvbzm0z7ngnqvja14cb2yz7p1ri6dy2wjk";
  };
  

  enableParallelBuilding = true;
}


