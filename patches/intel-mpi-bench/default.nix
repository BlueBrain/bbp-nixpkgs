{ stdenv
, fetchFromGitHub
, mpi
}:

stdenv.mkDerivation rec {
    name = "intel-mpi-benchmark-${version}";
    version = "2018";

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

    src = fetchFromGitHub {
        owner = "intel";
        repo = "mpi-benchmarks";
        rev = "v2018.0";
        sha256 = "15vxm94amabhimmgpj4kw1bmqwl44ii7f79rmb0p68a0kv4qyk9y";
    };

    buildInputs = [ mpi ];

    enableParallelBuilding = false;

    preBuild = ''
        pushd src
    '';

    makeFlags = [ "-f make_mpich" "MPICC=${mpi}/bin/mpicc" "MPI_HOME=${mpi}"];

    installPhase = ''
        install -d $out/bin
        install -D ./IMB-* $out/bin
    '';
}
