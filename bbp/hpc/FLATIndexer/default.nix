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
  version = "1.8.7";
  meta = {
    description = "Spatial index";
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
    rev = "a31336af3d3c90cffb6ed2686b99626bfa247be8";
    sha256 = "073vxabbl8w0i7mca750ry69r1b269n8h3ldvy4gjv9qgjg96g92";
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
  postInstall = [
       "mkdir -p $doc/share"
  ] ++ (stdenv.lib.optional) (pandoc != null) [ ''
    mkdir -p $out/share/doc/flatindexer/html
    ${pandoc}/bin/pandoc -s -S --self-contained \
      -c ${docCss} ${src}/README.txt \
      -o $out/share/doc/flatindexer/html/index.html
  '' ];
  outputs = [ "out"  "doc" ];
}
