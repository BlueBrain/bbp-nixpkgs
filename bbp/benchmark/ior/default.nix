{ stdenv
, fetchFromGitHub
, hdf5
, mpi
, perl
, zlib
, autoconf
, automake
}:

stdenv.mkDerivation rec {
  name = "ior-${version}";
  version = "3.0.1";

  meta = with stdenv.lib; {
    description = "Parallel filesystem I/O benchmark";
    longDescription = ''
      IOR can be used for testing performance of parallel
      file systems using various interfaces and access patterns.
      IOR uses MPI for process synchronization.
    '';
    homepage = https://github.com/LLNL/ior/;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "ior";
    rev = "${version}";
    sha256 = "0g62awdszpk94yiwiwrlgswsa7i1wcj8xaavxzvpqz0dr5cablc8";
  };

  passthru = {
    src = src;
  };

  buildInputs = [ stdenv hdf5 mpi autoconf automake perl zlib ] ;

  preConfigure = ''
    ./bootstrap
    export CFLAGS="-I${hdf5}/include -DH5_USE_16_API"
    export CPPFLAGS="-I${hdf5}/include -DH5_USE_16_API"
    export LDFLAGS="-L${hdf5}/lib"
  '';
  configureFlags = [ "--with-hdf5" ];
}
