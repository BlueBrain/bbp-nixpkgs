{ stdenv
, fetchurl
, mpi
}:


stdenv.mkDerivation rec {
    name = "intel-mpi-benchmark-${version}";
    version = "2017";

    src = fetchurl {
        url  = "https://software.intel.com/sites/default/files/managed/a3/53/IMB_2017.tgz";
        sha256 = "0sjwq3n2hpd6lr25dwkdvqd871v1rmjdyisfwb85brqf1gawqxd6";
    };

    buildInputs = [ mpi ];
    
    preBuild = "pushd imb/src";
    
    makeFlags = [ "-f make_mpich" "MPICC=${mpi}/bin/mpicc" "MPI_HOME=${mpi}"];
    
    installPhase = ''
        install -d $out/bin
        install -D ./IMB-* $out/bin
    '';

    enableParallelBuilding = false;

}
