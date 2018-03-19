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
        versionDate = "2018-03-16";
        rev = "f0c8828a50c601b13ea7d52e07206fb2b281d93d";
        sha256 = "0pb8zc02ada6923f8swchk4f04ql6q91cpwd9gc9lf1zb3f99shz";
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




