{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tbb-${version}";
  version = "2017";

  src = fetchurl {
    url = "https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb2017_20161128oss_src.tgz";
    sha256 = "0h55h108az3ygarpcs4ys4b46cbr1f3my70aacs0xsn86di1c2f0";
  };

  checkTarget = "test";
  doCheck = false;

  installPhase = ''
    mkdir -p $out/{lib,share/doc}
    cp "build/"*release*"/"*so* $out/lib/
    mv include $out/
    rm $out/include/index.html
    mv doc/html $out/share/doc/tbb
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Intel Thread Building Blocks C++ Library";
    homepage = "http://threadingbuildingblocks.org/";
    license = stdenv.lib.licenses.lgpl3Plus;
    longDescription = ''
      Intel Threading Building Blocks offers a rich and complete approach to
      expressing parallelism in a C++ program. It is a library that helps you
      take advantage of multi-core processor performance without having to be a
      threading expert. Intel TBB is not just a threads-replacement library. It
      represents a higher-level, task-based parallelism that abstracts platform
      details and threading mechanisms for scalability and performance.
    '';
    platforms = stdenv.lib.platforms.linux;
  };
}
