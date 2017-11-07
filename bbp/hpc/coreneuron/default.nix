{ stdenv
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

  src = fetchgit {
    url = "https://github.com/BlueBrain/Coreneuron";
    rev =  "e9ac6bf6a3bdba9ab1cc209b1b48cb97bdd1c990";
    sha256 = "24an66irqv2wyf0k0bbrvricybkdv9h0isqly83110lgjkfdb6gd";
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

}
