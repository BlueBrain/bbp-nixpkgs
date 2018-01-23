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
        versionDate = "2018-01-23";
        rev = "8e6356916f9a30c9200284ade9aa6cdec1452fbf";
        sha256 = "1k3hx9gjfc9r5qav9hcnn74rcccjc24n0qc5x3vyc054r76z4k9p";
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




