{ stdenv
, fetchurl
, mpi
}:

stdenv.mkDerivation rec {
    name = "intel-mpi-benchmark-${version}";
    version = "2017";

    meta = with stdenv.lib; {
        description = "perform a set of MPI performance measurements";
        longDescription = ''
            The Intel MPI Benchmarks perform a set of MPI performance
            measurements for point-to-point and global communication
            operations for a range of message sizes. The generated benchmark
            data fully characterizes:

            * Performance of a cluster system, including node performance,
              network latency, and throughput
            * Efficiency of the MPI implementation used
        '';
        homepage = https://software.intel.com/en-us/articles/intel-mpi-benchmarks;
        license = licenses.cpl10;
        platforms = platforms.unix;

    };

    src = fetchurl {
        url  = "https://software.intel.com/sites/default/files/managed/a3/53/IMB_2017.tgz";
        sha256 = "0sjwq3n2hpd6lr25dwkdvqd871v1rmjdyisfwb85brqf1gawqxd6";
    };

    buildInputs = [ mpi ];

    enableParallelBuilding = false;

    preBuild = ''
        env
        pushd imb/src
    '';

    makeFlags = [ "-f make_mpich" "MPICC=${mpi}/bin/mpicc" "MPI_HOME=${mpi}"];

    installPhase = ''
        install -d $out/bin
        install -D ./IMB-* $out/bin
    '';
}
