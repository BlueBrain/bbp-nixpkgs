{ stdenv
, fetchFromGitHub
, mpi
}:

stdenv.mkDerivation rec {
  name = "mdtest";
  version = "1.9.2";

  src = fetchFromGitHub {
  	owner = "LLNL";
  	repo = "mdtest";
  	rev = "49f3f047c254c62848c23226d6f1afa5fc3c6583";
	sha256 = "03s30k7fjjflk2jr4i8qxpv9gy10gswjh09x33ampda1rswvywfv";
  };

   meta = with stdenv.lib; {
    description = "Test metadata performance of a file system";
    longDescription = ''
      mdtest is a program that measures performance of various 
      metadata operations. It uses MPI to coordinate the operations
      and to collect the results.
    '';
    homepage = https://github.com/LLNL/mdtest/;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };

  passthru = {
  	src = src;
  };

  preConfigure = ''
    export MPI_CC=mpicc
  '';

  buildInputs = [ stdenv mpi ];

  installPhase = ''
    install -D mdtest $out/bin/mdtest
    install -D mdtest.1 $out/share/man/man1/mdtest.1
  '';
}
