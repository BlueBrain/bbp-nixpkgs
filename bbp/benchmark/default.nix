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

        stream = callPackage ./stream (
            if (icc-native != null) then {
                stdenv = stdenvICC;
                extra_cflags = [
                    "-mcmodel medium"
                    "-shared-intel"
                    "-qopenmp"
                    "-qopt-streaming-stores always"
                ];
            }
            else {}
        );
    };
in
  pkgs // benchmark_pkgs
