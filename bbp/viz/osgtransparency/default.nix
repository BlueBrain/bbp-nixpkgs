{ stdenv
, config
, fetchgitPrivate
, pkgconfig
, boost
, cmake
, openscenegraph
, opengl }:

stdenv.mkDerivation rec {
  name = "osgTransparency-${version}";
  version = "0.8.0-dev201708";

  buildInputs = [ stdenv pkgconfig boost cmake openscenegraph ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/viz/osgTransparency";
    rev = "e7763676d2844c18eab13607679d2a999f57a3f0";
    sha256 = "0939ifn1fwxd83kf7iqc9xd2vcj6gcdkm1gpy396bk0fjw4cd6fb";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ openscenegraph opengl ];

}


