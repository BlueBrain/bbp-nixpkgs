{ stdenv
, fetchurl
, cmake
, gfortran
, libjpeg
, openblas
, mesa
, hdf5
, fltk
, gmp
, opencascade
}:


stdenv.mkDerivation rec {
    name = "gmsh-${version}";
    version = "2.14.0";

    src = fetchurl {
        url  = "http://gmsh.info/src/gmsh-${version}-source.tgz";
        sha256 = "1kcig4kb8jhkx8nrxzwch0k0nqv18j2w9z2qh5bng4g9mhllyd4b";
    };

    buildInputs = [ cmake gfortran libjpeg openblas mesa hdf5 fltk gmp opencascade ];

    enableParallelBuilding = true;


}
