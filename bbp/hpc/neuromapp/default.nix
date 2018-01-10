{ boost
, cmake
, config
, doxygen
, fetchFromGitHub
, hdf5
, mpiRuntime
, ncurses
, pandoc
, pkgconfig
, readline
, stdenv
, zlib }:

stdenv.mkDerivation rec {
  name = "neuromapp-${version}";
  version = "2017.06";
  meta = {
    description = "BBP algorithms mini-apps";
    homepage = https://github.com/BlueBrain/neuromapp;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with config.maintainers; [
      adevress
      brunomaga
      jplanasc
      pramodskumbhar
      sharkovsky
      till
      timocafe
    ];
  };

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "neuromapp";
    rev = "7c5bea38a577d21250ab5986186f100d74e7a4f9";
    sha256 = "0s1q8by7zq917gwxkdw7s6c5qj9jpizqxfsnvi1nxy0y1diz89xv";
  };

  cmakeFlags= [
    "-DBoost_NO_BOOST_CMAKE=TRUE"
    "-DBoost_USE_STATIC_LIBS=FALSE"
  ];

  buildInputs = [
    boost
    cmake
    doxygen
    hdf5
    mpiRuntime
    ncurses
    pkgconfig
    readline
    stdenv
    zlib
  ];

  enableParallelBuilding = true;

  docCss = ../../common/vizDoc/github-pandoc.css;
  postInstall = ''
    mkdir -p $out/share/doc/neuromapp/html
    ${pandoc}/bin/pandoc -s -S --self-contained \
      -c ${docCss} ${src}/README.md \
      -o $out/share/doc/neuromapp/html/index.html
  '';
  outputs = [ "out" "doc" ];
}
