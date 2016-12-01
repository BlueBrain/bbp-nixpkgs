{ stdenv
, fetchurl
, mpi
}:


stdenv.mkDerivation rec {
    name = "osu-mpi-benchmark-${version}";
    version = "5.3.2";

    src = fetchurl {
        url  = "http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-${version}.tar.gz";
        sha256 = "1sjwq3n2hpd6lr25dwkdvqd871v1rmjdyisfwb85brqf1gawqxd6";
    };

    buildInputs = [ mpi ];
    
    
    
  #  installPhase = ''
  #      install -d $out/bin
  #      install -D ./IMB-* $out/bin
  #  '';

    enableParallelBuilding = false;

}
