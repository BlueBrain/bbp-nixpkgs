{ bbpsdk,
boost,
brion,
cmake,
config,
doxygen,
fetchgitPrivate,
hdf5,
lunchbox,
mpiRuntime,
numpy,
pandoc,
pkgconfig,
python,
servus,
sparsehash,
stdenv,
vmmlib,
zlib }:

stdenv.mkDerivation rec {
  name = "flatindexer-${version}";
  version = "1.8.4-201711";
  meta = {
    description = "facilitate SIMD programming";
    homepage = "https://bbpcode.epfl.ch/code/#/admin/projects/building/FLATIndex";
    repository = "ssh://bbpcode.epfl.ch/building/FLATIndex";
    license = {
      fullName = "Copyright 2018, Blue Brain Project";
    };
    maintainers = with config.maintainers; [
      tristan0x
    ];
  };

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/FLATIndex";
    rev = "849bb3f56bad2535fdc93a85ed9c229e5e4094e8";
    sha256 = "137cjp7k2mgk40nxfmdqbj9amzbv5xvvnzvr00gxncda9rdi4rr7";
  };

  buildInputs = [
    bbpsdk
    boost
    brion
    cmake
    doxygen
    hdf5
    lunchbox
    numpy
    pkgconfig
    python
    servus
    sparsehash
    stdenv
    vmmlib
    zlib
  ];
  cmakeFlags= [ "-DCOMMON_DISABLE_WERROR=TRUE" ];

  enableParallelBuilding = true;

  docCss = ../../common/vizDoc/github-pandoc.css;
  postInstall = ''
    mkdir -p $out/share/doc/flatindexer/html
    ${pandoc}/bin/pandoc -s -S --self-contained \
      -c ${docCss} ${src}/README.txt \
      -o $out/share/doc/flatindexer/html/index.html
  '';
  outputs = [ "out" "doc" ];
}
