{ stdenv, cmake, fetchgit }:

stdenv.mkDerivation rec {
  name = "dcmtk-${version}";
  version = "3.6.4";

  src = fetchgit {
    url = "http://git.dcmtk.org/dcmtk";
    rev = "1967b13134308f311e6a827e616958c6a4da5bc9";
    sha256 = "0fbx35zax8n4gayaac5bankqwzg2y2adggykbbf8lpd773jfxsp6";
  };

  buildInputs = [ stdenv cmake ];

}
