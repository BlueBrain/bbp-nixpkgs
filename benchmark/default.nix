{
  pkgs,
}:

let
    benchmark_pkgs = with pkgs; rec {
        mdtest = callPackage ./mdtest {
            mpi = mvapich2;
        };

        ior = callPackage ./ior {
            mpi = mvapich2;
            hdf5 = phdf5.override {
                mpi = mvapich2;
            };
        };

        stream = callPackage ./stream {
          stdenv = stdenvICC;
        };
    };
in
  pkgs // benchmark_pkgs
