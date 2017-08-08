{
  pkgs,
}:

let
    benchmark_pkgs = with pkgs; rec {
        mdtest = callPackage ./mdtest {
            mpi = mvapich2;
        };
    };
in
  pkgs // benchmark_pkgs
