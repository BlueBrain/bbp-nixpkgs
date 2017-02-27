#!/bin/bash

## map cray mpich into nix store
mkdir -p $out/{bin,include,lib}
cp -r ${cray_mpi_path}/lib/* $out/lib
cp -r ${cray_mpi_path}/include/* $out/include

export compiler_bin="${compiler_dir}/bin/${ccName}"


substituteAll ${./mpicc.in} $out/bin/mpicc

export compiler_bin="${compiler_dir}/bin/${cxxName}"
substituteAll ${./mpicc.in} $out/bin/mpic++

