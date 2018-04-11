{ stdenv
, config
, fetchgit
, python
, perl
, cmake
, boost
, pkgconfig
, mpiRuntime
, bison
, flex
, neurodamus
, frontendCompiler ? null
}:

stdenv.mkDerivation rec {
  name = "coreneuron-${version}";
  version = "1.0.1-dev201710";

  meta = {
    description = "Optimized simulator engine for NEURON";
    homepage = "https://github.com/BlueBrain/Coreneuron";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with config.maintainers; [
      jamesgkind
      pramodskumbhar
      fouriaux
    ];
  };

  src = fetchgit {
    url = "https://github.com/BlueBrain/Coreneuron";
    rev =  "4cf570aeeb294565dbc52779f63f44f34ff8e58d";
    sha256 = "071k1pw8va8rvamwbr9wwrb806jsa4m1kzv3igsrpm52bsjiymn2";
  };


  buildInputs = [ boost bison flex mpiRuntime ];

  nativeBuildInputs= [ python perl pkgconfig cmake ];

  cmakeFlags= [ 
                "-DADDITIONAL_MECHPATH=${neurodamus.src}/lib/modlib/"
                "-DADDITIONAL_MECHS=${neurodamus.src}/lib/modlib/coreneuron_modlist.txt"
  ]
  ++ (stdenv.lib.optionals) (frontendCompiler != null) [ 
                "-DFRONTEND_C_COMPILER=${frontendCompiler}/bin/cc"
                "-DFRONTEND_CXX_COMPILER=${frontendCompiler}/bin/c++"
  ];

  outputs = [ "out" "doc" ];

  postInstall =  ''
    mkdir -p $out/share/doc/coreneuron/html
    echo '<html><head><meta http-equiv="refresh" content="0; URL=${src.url}"/></head></html>' >$out/share/doc/coreneuron/html/index.html
  '';
}
