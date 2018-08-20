{ stdenv
, requireFile
, utils
, patchelf
, ibverbs ? null
, which
}:

stdenv.mkDerivation rec {
  name = "hpe-mpi-${version}";
  version = "2.16";

  src = requireFile {
      name = "${name}.tar.gz";
      sha256 = "1ryw0skfqfwyd8bxaad1vidqar50fzlskap2pc74yvwf593lvkzi";
      message = ''
        This nix expression requires that hpe MPI is installed on your system to map it into the store
  please create a tarball of the intel hpe directory and import it into the nix store with
    nix-prefetch-url file://{name}
      '';
  };

  additionalMapPhase = ''
    cp /usr/lib64/libcpuset.so* $out/lib
    cp /usr/lib64/libbitmask.so* $out/lib
    cp /usr/lib64/libpmi2.so* $out/lib

    # remove local reference in wrapper and also force ihm to use generic compiler instead of gcc / g++
    sed 's@/usr/lib64/@-l@g' -i $out/bin/mpicc
    sed 's@gcc@cc@g' -i $out/bin/mpicc

    sed 's@/usr/lib64/@-l@g' -i $out/bin/mpicxx
    sed 's@g++@c++@g' -i $out/bin/mpicxx
    substituteInPlace $out/bin/mpicc \
      --replace which ${which}/bin/which \
      --replace -llibcpuset.so.1 -lcpuset \
      --replace -llibbitmask.so.1 -lbitmask

    substituteInPlace $out/bin/mpicxx \
      --replace which ${which}/bin/which \
      --replace -llibcpuset.so.1 -lcpuset \
      --replace -llibbitmask.so.1 -lbitmask

    substituteInPlace $out/bin/mpif90 \
      --replace which ${which}/bin/which \
      --replace /usr/lib64/libcpuset.so.1 -lcpuset \
      --replace /usr/lib64/libbitmask.so.1 -lbitmask

    ln -s mpicxx $out/bin/mpic++
    '';

  installPhase = ''
    echo " ** Installing HPE MPI ** "
    cd ..
    mv ${name} $out
    eval "${additionalMapPhase}"
    echo " ** rewire on Nix libc ** "
    echo " ** rewire interpreter ** "
    find $out/{lib,bin} -type f | xargs -n 1 -I {}  patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" {} ||true

    echo " ** rewire ld path ** "
    find $out/{lib,bin} -type f | xargs -n 1 -I {}  patchelf --set-rpath "$out/lib:${stdenv.cc.cc}/lib:${stdenv.cc.libc}/lib:${ibverbs}/lib" {} ||true
  '';
  dontPatchELF = true;
}
