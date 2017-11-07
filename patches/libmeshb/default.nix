{
  cmake,
  fetchFromGitHub,
  stdenv
}:

stdenv.mkDerivation rec {
  name = "libmeshb-${version}";
  version = "7.29";

  src = fetchFromGitHub {
    owner = "LoicMarechal";
    repo = "libMeshb";
    rev = "220a1ae259969fcab5276faa1d7308cca90429d6";
    sha256 = "0vwabgmqk5x7mmnv3pn4hicmbs4gqd1m4m5niv43pzh19aliygll";
  };

  passthru = {
    src = src;
  };

  meta = {
    description = "A library to handle the *.meshb file format";
    longDescription = ''
      The Gamma Mesh Format (GMF) and the associated library libMeshb provide
      programers of simulation and meshing software with an easy way to store
      their meshes and physical solutions.
      The GMF features more than 80 kinds of data types, like vertex,
      polyhedron, normal vector or vector solution field.
      The libMeshb provides a convenient way to move data between those files,
      via keyword tags, and the user's own structures.
      Transparent handling of ASCII & binary files.
      Transparent handling of little & big endian files.
      Optional ultra fast asynchronous and low level transfers.
      Can call user's own pre and post processing routines in a separate
      thread while accessing a file.
    '';
    platforms = stdenv.lib.platforms.all;
    homepage = "https://github.com/LoicMarechal/libMeshb";
    license = stdenv.lib.licenses.lgpl3;
  };

  buildInputs = [
    cmake
    stdenv
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS:BOOL=ON"
  ];
}
