{ stdenv, fetchurl, python, perl, gfortran }:

let version = "3.1"; in
stdenv.mkDerivation {
  name = "mpich2-${version}";

  src = fetchurl {
    url = "http://www.mpich.org/static/downloads/${version}/mpich-${version}.tar.gz";
    sha256 = "fcf96dbddb504a64d33833dc455be3dda1e71c7b3df411dfcf9df066d7c32c39";
  };

  configureFlags = "--enable-shared --enable-sharedlib";

  buildInputs = [ python perl gfortran ];
  propagatedBuildInputs = stdenv.lib.optional (stdenv ? glibc) stdenv.glibc;


  outputs = [ "out" "doc" ];

  meta = {
    description = "Implementation of the Message Passing Interface (MPI) standard";

    longDescription = ''
      MPICH2 is a free high-performance and portable implementation of
      the Message Passing Interface (MPI) standard, both version 1 and
      version 2.
    '';
    homepage = http://www.mcs.anl.gov/mpi/mpich2/;
    license = "free, see http://www.mcs.anl.gov/research/projects/mpich2/downloads/index.php?s=license";

    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
