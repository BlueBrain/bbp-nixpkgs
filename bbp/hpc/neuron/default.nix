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
        versionDate = "2017-08-06";
        rev = "ee80eb94d3f34e86299a0498b5c1b87f8e8bcaa3";
        sha256 = "0msca5q8yf42scmgfj932vbhzs57yaiy11hydr4vy9zhnzp5kk8r";
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




