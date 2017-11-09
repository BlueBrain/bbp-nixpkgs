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
        versionDate = "2017-11-03";
        rev = "31c795da0886657733ec364020b092ce618cbdba";
        sha256 = "0hsqp5qn6vck5gnkf92y86a7jz0c8b4r3vlpcih08n68hcc7s5i5";
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




