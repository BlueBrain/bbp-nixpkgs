{ stdenv
, config
, fetchgit
, libwebsockets
, boost
, cmake
}:

stdenv.mkDerivation rec {
  name = "rockets-${version}";
  version = "latest";

  buildInputs = [ stdenv boost cmake libwebsockets ];

  src = fetchgit {
    url  = "https://github.com/BlueBrain/Rockets.git";
    rev = "4ee5e2d14005c1623559e8723a499ad32dc818a8";
    sha256 = "11137gss3f9q8vb1n53rz07r2qw8xfnh368hpgpxm7mdh2mwxjil";
  };

  enableParallelBuilding = true;
}
