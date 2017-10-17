{ autoreconfHook,
  fetchgit,
  libibumad,
  libibverbs,
  librdmacm,
  stdenv
}:

stdenv.mkDerivation rec {
  name = "perftest";
  version = "2015-03";

  meta = with stdenv.lib; {
    description = "Set of bandwidth and latency InfiniBand benchmarks";
    longDescription = ''
      perftest package is a collection of tests written over uverbs intended
      for use as a performance micro-benchmark. The tests may be used for
      tuning as well as for functional testing.
    '';
    homepage = "https://community.mellanox.com/docs/DOC-2802";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };

  src = fetchgit {
    url = "git://git.openfabrics.org/~grockah/perftest.git";
    rev = "b727d9c491e3573a1c92e6cb41bd5e7cb9db70c5";
    sha256 = "1rwb4nrw2nk4lqlwypj1w9x5ffaa4yp6ypm9yaidnrwrhm8s7jzh";
  };

  passthru = {
    src = src;
  };

  buildInputs = [
    autoreconfHook
    libibumad
    libibverbs
    librdmacm
    stdenv
  ];
}
