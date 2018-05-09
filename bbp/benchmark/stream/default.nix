{ stdenv
, fetchFromGitHub
, extra_cflags ? [ ]
}:

stdenv.mkDerivation rec {
  name = "STREAM-${version}";
  version = "5.10";

  src = fetchFromGitHub {
    owner = "jeffhammond";
    repo = "STREAM";
    rev = "32e57a2571890b7a2b6628b5d2d4b7b3fae947b8";
    sha256 = "00r88rywxz34chl6whhpjzfbkjnb509qdjzd7bv34wi7bwvw6hwi";
  };

  passthru = {
    src = src;
  };

  meta = {
    description = "Measures sustainable memory bandwidth and computation rate";
    longDescription = ''
      The STREAM benchmark is a simple synthetic benchmark program that
      measures sustainable memory bandwidth (in MB/s) and the corresponding
      computation rate for simple vector kernels.

      STREAM is the de facto industry standard benchmark
      for measuring sustained memory bandwidth.
    '';
    homepage = http://www.cs.virginia.edu/stream/ref.html;
  };

  # Intel KNL: -xMIC-AVX512
  # IBM Power 9: -qarch=pwr9 -qtune=pwr9 -qhot -O3 -q64 \
  #              -qsmp=omp -qsimd=auto -qprefetch=aggressive \
  #              -qaltive=be automat \
  #              -DN=134217728 -DOFFSET=0 -DNTIMES=10

  cflags = [
    "-O3"
    "-DOFFSET=0"
    "-DNTIMES=20"
    "-DTUNE"
    "-DSTREAM_ARRAY_SIZE=160000000" # 152MB
    "-mcmodel=medium"
  ] ++ stdenv.lib.optionals ( stdenv ? isICC )  [
    "-shared-intel"
    "-ffreestanding"
    "-qopenmp"
    "-qopt-streaming-stores always"
  ] ++ stdenv.lib.optionals (! stdenv ? isICC) [
    "-fopenmp"
  ] ++ extra_cflags;

  cflags_str = builtins.concatStringsSep
    " " (cflags);

  postPatch = ''
    sed -e "/^CC =/d" -i Makefile
    sed -e "s/^CFLAGS =.*/CFLAGS = ${cflags_str}/" -i Makefile
  '';

  buildFlags = "stream_c.exe";

  installPhase = ''
    install -D ./stream_c.exe $out/bin/stream_c
  '';
}
