{
stdenv,
fetchFromGitHub,
callPackage,
isBlueGene,
... } @ args:

let

    neuron-info = {
        versionMajor = "7";
        versionMinor = "5";
        versionDate = "2018-05-01";
        rev = "6819979820ecb26394f2c1930eeb5fdd43cb7856";
        sha256 = "1bzssvafm7zdmvp7gkglcl0k487wwmvlfk4lfvs8xqqd9rmr57dq";
    };

    neuron-src = rec {
        info = neuron-info;

        srcs = fetchFromGitHub {
            owner = "nrnhines";
            repo = "nrn";
            rev = info.rev;
            sha256 = info.sha256;
        };
    };

    interview = callPackage ./interview.nix ( args // rec {

    });

    # compile neuron on BGQ is journey
    # where neuron need to be compiled twice
    bgq-neuron-modl = callPackage ./bgq.nix (args // rec {
        mpiRuntime = null;
        modlOnly = true;
        inherit neuron-src;
    });

    bgq-neuron-nrn =  callPackage ./bgq.nix ( args // rec {
        nrnModl = bgq-neuron-modl;
        nrnOnly = true;
        inherit neuron-src;
    });


    neuron-generic = callPackage ./generic.nix ( args // rec {
        inherit neuron-src;
        inherit interview;
    });

in
    if (isBlueGene) then bgq-neuron-nrn else neuron-generic




