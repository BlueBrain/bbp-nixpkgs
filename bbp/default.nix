# All BBP related pkgs
{
 std-pkgs,
 config
}:

let
    pkgFun =
    pkgs:
      with pkgs;
      let
        # detect if the platform is with slurm or not
        has_slurm = builtins.pathExists "/usr/bin/srun";

        # if not available, map to default mpi library
        bbp-mpi = if pkgs.isBlueGene == true then ibm-mpi-xlc
                  else if (config ? isSlurmCluster == true)  then mvapich2
                  else if (config.mpi.rdma  or false ) then mvapich2-rdma
                  else mvapich2-hydra;

        # proper BBP default MPI library forced to GCC, necessary on some platforms
        bbp-mpi-gcc = if pkgs.isBlueGene == true then ibm-mpi else bbp-mpi;

        # callpackage mapper
        callPackage = newScope mergePkgs;

        enableBGQ-proto = caller: file: map:
        if mergePkgs.isBlueGene == true
            then (newScope (mergePkgs // map)) file
            else caller file;

        # using this function before a package will enable
        # all the required cross-compilation magic for BlueGene/Q
        enableBGQ = caller: file: (enableBGQ-proto caller file mergePkgs.bgq-map);

        # same than enableBGQ, but provide a GNU GCC environment
        enableBGQ-gcc47 = caller: file: (enableBGQ-proto  caller file mergePkgs.bgq-map-gcc47);

        # define this derivation to NULL if used on BlueGeneQ
        noBGQ = argPkg: (if pkgs.isBlueGene then stdenv else argPkg);

        pkgsWithBGQGCC = if (pkgs.isBlueGene == true) then (pkgs // mergePkgs.bgq-map-gcc47) else pkgs;
        pkgsWithBGQXLC = if (pkgs.isBlueGene == true) then (pkgs // mergePkgs.bgq-map) else pkgs;

        nativeAllPkgs = pkgs;

    mergePkgs = pkgs // rec {

        inherit bbp-mpi;

        intel-mpi-bench = pkgs.intel-mpi-bench.override {
            mpi = bbp-mpi;
        };

        hpe-mpi = pkgs.hpe-mpi.override {
            ibverbs = ibverbs-upstream;
        };

        osu-mpi-bench = pkgs.osu-mpi-bench.override {
            mpi = bbp-mpi;
        };

        pandoc = if (config.buildDocumentation or true) then pkgs.pandoc else null;

        ## parallel hdf5
        phdf5 = pkgs.phdf5.override {
            mpi = bbp-mpi;
        };

        adios = pkgs.adios.override {
            mpi = bbp-mpi;
        };

        ## override component that need bbp-mpi
        petsc = pkgs.petsc.override {
            stdenv = enableDebugInfo  pkgsWithBGQGCC.stdenv;
            mpiRuntime = bbp-mpi;
        };

        scorec = pkgs.scorec.override {
            mpi = bbp-mpi;
            parmetis = parmetis;
            zoltan = zoltan;
        };

        parmetis = pkgs.parmetis.override {
            mpi = bbp-mpi;
        };

        trilinos = pkgs.trilinos.override {
            mpi = bbp-mpi;
            parmetis = parmetis;
        };

        zoltan = trilinos;


        ##
        ## git / cmake external for viz components
        ##
        fetchgitExternal = callPackage ./config/fetchGitExternal {};

        ##
        ## cmake externals for viz components
        ## might cause not deterministic builds
        ##
        cmake-external = callPackage ./config/cmake-external {};


        ##
        ## BBP common components
        ##
        bbpsdk = callPackage ./common/bbpsdk {};

        bbpsdk-legacy = bbpsdk.override {
            legacyVersion = true;
            brion = brion-legacy;
            lunchbox = lunchbox-legacy;
        };

        libsonata = callPackage ./common/libsonata {
        };

        libsonata-py3 = callPackage ./common/libsonata {
            python = python3;
            pythonPackages = python3Packages;
        };

        vmmlib = callPackage ./common/vmmlib {};

        ##
        ## BBP viz components
        ##
        opengl = mesa;

        qt = qt59;

        servus = callPackage ./viz/servus {};

        lunchbox = callPackage ./viz/lunchbox {};

        lunchbox-legacy = callPackage ./viz/lunchbox {
            legacyVersion = true;
        };

        keyv = callPackage ./viz/keyv {};

        keyv-legacy = callPackage ./viz/keyv {
            lunchbox = lunchbox-legacy;
            pression = pression-legacy;
        };

        cppnetlib = callPackage ./viz/cppnetlib {};

        rockets = callPackage ./viz/rockets {};

        brion = callPackage ./viz/brion {};

        brion-py3 = brion.override {
            pythonPackages = python3Packages;
            boost = boost-py3;
        };

        brion-legacy = callPackage ./viz/brion {
            legacyVersion = true;
            lunchbox = lunchbox-legacy;
            keyv = keyv-legacy;
        };

        pression = callPackage ./viz/pression {};

        pression-legacy = callPackage ./viz/pression {
            lunchbox = lunchbox-legacy;
        };

        collage = callPackage ./viz/collage {};

        deflect = callPackage ./viz/deflect {};

        hwsd = callPackage ./viz/hwsd {};

        ior = callPackage ./benchmark/ior {
            mpi = bbp-mpi;
            hdf5 = phdf5.override {
                mpi = bbp-mpi;
            };
        };

        perftest = callPackage ./benchmark/perftest {};

        shoc = callPackage ./benchmark/shoc {
            mpi = bbp-mpi;
        };

        babelstream = callPackage ./benchmark/babelstream {
        };

        hpl = callPackage ./benchmark/hpl {
            stdenv = stdenvIntelfSupported;
            mpi = bbp-mpi;
            blas = intelMKLIfSupported;
        };

        mt-dgemm = callPackage ./benchmark/mt-dgemm {
            blas = blis;
            };

        mt-dgemm-intel = callPackage ./benchmark/mt-dgemm {
            blas = intel-mkl;
            stdenv = stdenvIntelfSupported;
        };

        iperf = callPackage ./benchmark/iperf {};

        osgtransparency = callPackage ./viz/osgtransparency {};

        regiodesics = callPackage ./viz/regiodesics {};

        equalizer = callPackage ./viz/equalizer {};

        rtneuron = callPackage ./viz/rtneuron {};

        rtneuron2 = callPackage ./viz/rtneuron {
            legacyVersion = true;
        };

        dcmtk = callPackage ./viz/dcmtk {
        };

        embree = callPackage ./viz/embree {
            stdenv = stdenvIntelIfSupportedElseClang;
        };

        ospray = callPackage ./viz/ospray {
            stdenv = llvmPackages_5.stdenv;
            mpi = bbp-mpi;
        };

        ospray-modules = callPackage ./viz/ospray-modules {
            stdenv = stdenvIntelIfSupportedElseClang;
        };

        optix = callPackage ./viz/optix {};

        brayns = callPackage ./viz/brayns {
            stdenv = llvmPackages_5.stdenv;
        };

        viztools = callPackage ./viz/viztools {};

        emsim = callPackage ./viz/emsim {};

        meshball = callPackage ./viz/meshball {};

        ## BBP VIZ plugins

        dti = callPackage ./viz/dti {};

        brain-atlas = callPackage ./viz/brain-atlas {};

        circuit-explorer = callPackage ./viz/circuit-explorer {};

        membraneless-organelles = callPackage ./viz/membraneless-organelles {};

        molecular-systems = callPackage ./viz/molecular-systems {};

        morphology-synthesis = callPackage ./viz/morphology-synthesis {};

        topology-viewer = callPackage ./viz/topology-viewer {};

        ##
        ## BBP NSE components
        ##
        neurom = callPackage ./nse/neurom {
        };

        neurom-py3 = neurom.override {
            pythonPackages = python3Packages;
        };

        morphio-python = callPackage ./nse/morphio-python {
        };

        morphio = callPackage ./nse/morphio {
        };

        bbp-morphology-workflow = callPackage ./nse/bbp-morphology-workflow {
        };

        morphsyn = callPackage ./nse/morphsyn {
        };

        bluejittersdk = callPackage ./nse/bluejittersdk {
            bbpsdk = bbpsdk-legacy;
        };

        bluepy_0_6_1 = callPackage ./nse/bluepy/legacy.nix {
        };

        bluepy_0_9_6 = callPackage ./nse/bluepy/legacy.nix {
            bluepy_version = "0.9.6";
        };

        bluepy = callPackage ./nse/bluepy {
        };

        bluepy-py3 = bluepy.override {
            bluepy-configfile = bluepy-configfile-py3;
            brion = brion-py3;
            entity-management = entity-management-py3;
            flatindexer = flatindexer-py3;
            neurom = neurom-py3;
            voxcell = voxcell-py3;
            pythonPackages = python3Packages;
            libsonata = libsonata-py3;
        };

        bluepy-configfile = callPackage ./nse/bluepy-configfile {
        };

        bluepy-configfile-py3 = bluepy-configfile.override {
            pythonPackages = python3Packages;
        };

        pybinreports = callPackages ./nse/pybinreports {
        };

        bglibpy = callPackage ./nse/bglibpy {
        };

        bluepyopt = callPackage ./nse/bluepyopt {
        };

        igorpy = callPackage ./nse/igorpy {
        };

        bluepyefe = callPackage ./nse/bluepyefe {
        };

        bluepymm = callPackage ./nse/bluepymm {
        };

        bluerepairsdk = callPackage ./nse/bluerepairsdk {
            bbpsdk = bbpsdk-legacy;
        };

        muk = callPackage ./nse/muk {
            brion = brion-legacy;
            bbpsdk = bbpsdk-legacy;
        };

        morphscale = callPackage ./nse/morphscale {
            bbpsdk = bbpsdk-legacy;
        };

        brainbuilder = callPackage ./nse/brainbuilder {
        };

        connectome-tools = callPackage ./nse/connectome-tools {
        };

        morph-tool = callPackage ./nse/morph-tool {
        };

        placement-algorithm = callPackage ./nse/placement-algorithm {
        };

        projectionizer = callPackage ./nse/projectionizer {
        };

        psp-validation = callPackage ./nse/psp-validation {
        };

        voxcell = callPackage ./nse/voxcell {
        };

        voxcell-py3 = voxcell.override {
            pythonPackages = python3Packages;
        };

        simwriter = callPackage ./nse/simwriter {
        };

        bbp-analysis-framework = callPackage ./nse/bbp-analysis-framework {
        };

        entity-management = callPackage ./nse/entity-management {
        };

        entity-management-py3 = entity-management.override {
            pythonPackages = python3Packages;
        };

        entity-management_0_1_5 = callPackage ./nse/entity-management {
            version = "0.1.5";
            rev = "7230d6cb662700cd62f7cd4d3a51397be443097d";
            sha256 = "09ya1mqyw2imnhr7636cai4b2v7k6p8akmkxz2nv8madlcq3r5xm";
        };

        nse-allpkgs = noBGQ (pkgs.buildEnv {
            name = "all-modules";
            paths =
                [
                    bluejittersdk
                    bluepy
                    bluerepairsdk
                    brainbuilder
                    morphscale
                    morphsyn
                    muk
                    voxcell
                ];
        });

        ##
        ## BBP INS components
        ##



        ##
        ## BBP HPC components
        ##
        helloworld = enableBGQ-gcc47 callPackage ./common/helloworld {
            mpi = bbp-mpi;
        };

        hpctools-xlc = enableBGQ callPackage ./hpc/hpctools {
            mpiRuntime = bbp-mpi;
        };

        hpctools = enableBGQ-gcc47 callPackage ./hpc/hpctools {
            stdenv = enableDebugInfo  pkgsWithBGQGCC.stdenv;
            mpiRuntime = bbp-mpi-gcc;
        };

        functionalizer = enableBGQ callPackage ./hpc/functionalizer {
            python = nativeAllPkgs.python;
            pythonPackages = nativeAllPkgs.pythonPackages;
            mpiRuntime = bbp-mpi;
            hpctools = hpctools-xlc;
        };

        parquet-converters = callPackage ./hpc/parquet_converters {
            mpiRuntime = bbp-mpi;
        };

        spykfunc = callPackage ./hpc/spykfunc {
        };

        touchdetector = enableBGQ callPackage ./hpc/touchdetector {
            mpiRuntime = bbp-mpi;
            hpctools = hpctools-xlc; # impossible to use MPI 3.2 for now on BGQ
        };

        bluebuilder = enableBGQ callPackage ./hpc/bluebuilder {
            hpctools = hpctools-xlc;
            mpiRuntime = bbp-mpi;
        };

        pytouchreader = callPackage ./hpc/pytouchreader {};

        pytouchreader-py3 = pytouchreader.override {
            pythonPackages = python3Packages;
        };

        mdtest = callPackage ./benchmark/mdtest {
            mpi = bbp-mpi;
        };

        mvdtool = callPackage ./hpc/mvdTool {};

        morphotool = callPackage ./hpc/morphotool {};

        morphomesher = callPackage ./hpc/morphomesher {
            # we use clang to compile morpho mesher
            # due to the very high memory consumption at compiled time
            # implied by CGAL
            stdenv = clangStdenv;
        };

        synapsetool = callPackage ./hpc/synapsetool {};

        synapsetool-phdf5 = callPackage ./hpc/synapsetool {
            hdf5 = phdf5;
            useMPI = true;
        };

        highfive = callPackage ./hpc/highfive {};

        highfive-phdf5 = highfive.override {
            hdf5 = phdf5;
        };

        flatindexer = callPackage ./hpc/FLATIndexer {
            mpiRuntime = bbp-mpi;
        };

        flatindexer-py3 = flatindexer.override {
            mpiRuntime = bbp-mpi;
            boost = boost-py3;
            python = python3;
            pythonPackages = python3Packages;
        };

        bbptestdata = callPackage ./tests/BBPTestData {};

        ### simulation

        cyme = callPackage ./hpc/cyme {};

        learningengine = callPackage ./hpc/learningengine {
        #    stdenv = stdenvIntelfSupported;
        #    blas = intelMKLIfSupported;
        };

        mod2c = callPackage ./hpc/mod2c {};

        coreneuron = enableBGQ callPackage ./hpc/coreneuron {
            mpiRuntime = bbp-mpi;
            neurodamus = neurodamus-coreneuron;
            frontendCompiler = if (pkgs.isBlueGene) then gcc else null;
        };

        bluron = enableBGQ callPackage ./hpc/bluron/cmake-build.nix {
            mpiRuntime = bbp-mpi;
        };

        neuron = enableBGQ callPackage ./hpc/neuron {
            stdenv = (enableDebugInfo pkgsWithBGQXLC.stdenv);
            mpiRuntime = bbp-mpi;
            isBlueGene = pkgs.isBlueGene;
        };

        neuron-nomultisend = neuron.override {
            multiSend = false;
        };

        reportinglib = enableBGQ callPackage ./hpc/reportinglib {
            mpiRuntime = bbp-mpi;
        };

        neurodamus = enableBGQ callPackage ./hpc/neurodamus {
            mpiRuntime = bbp-mpi;
            nrnEnv = mergePkgs.neuron;
            # synapse-tool is disabled on BlueGene because it requires C++-11
            withSyntool = !pkgs.isBlueGene;
        };

        neurodamus-coreneuron = neurodamus.override {
            coreNeuronMode = true;
         };

        neurodamus-savestate = neurodamus.override {
            branchName = "savestate";
         };

        neurodamus-hippocampus = neurodamus.override {
            branchName = "hippocampus";
         };

        neurodamus-simplification = neurodamus.override {
            branchName = "simplification";
         };

        neurodamus-mousify = neurodamus.override {
            branchName = "mousify";
         };

        neurodamus-bare = neurodamus.override {
            branchName = "bare";
        };

        neuromapp = enableBGQ callPackage ./hpc/neuromapp {
            mpiRuntime = bbp-mpi;
        };

        mods-src = callPackage ./hpc/neurodamus/corebluron.nix {};


        nest = enableBGQ callPackage ./hpc/nest {
            mpiRuntime = bbp-mpi;
        };

        ##
        ## sub-cellular simulation
        ##

        rdmini = callPackage ./hpc/rdmini {
            ghc = haskellPackages.ghcWithPackages(haskellPackages:
            with haskellPackages; [  ]);
        };

        steps = enableBGQ-gcc47 callPackage ./hpc/steps {
            mpiRuntime = if (mergePkgs.isBlueGene) then bbp-mpi-gcc else bbp-mpi;

            stdenv = enableDebugInfo  pkgsWithBGQGCC.stdenv;

            numpy = if (mergePkgs.isBlueGene) then  mergePkgs.bgq-pythonPackages-gcc47.bg-numpy
                else pythonPackages.numpy;

            liblapack = if (mergePkgs.isBlueGene) then bgq-openblas
                  else openblasCompat;

            blas =  if (mergePkgs.isBlueGene) then bgq-openblas
                  else openblasCompat;
        };

        steps-mpi = steps; # enable mpi by default

        zee = callPackage ./hpc/zee {
            petsc = petsc.override {
                withHypre = true;
                withDebug = false;
            };
        };

        steps-mpi-py3 = steps.override {
            python = python3;
            pythonPackages = python3Packages;
            cython = python3Packages.cython;
            numpy = python3Packages.numpy;
        };

        steps-validation = callPackage ./hpc/steps_validation {
            steps = steps-mpi;
        };

        stream = callPackage ./benchmark/stream {
            stdenv = stdenvIntelfSupported;
        };

        mpi4py-py27-bbp = pythonPackages.mpi4py.override {
            mpi = bbp-mpi;
        };

        modules = (import ./modules) { pkgs = mergePkgs; };

        hpc-doc = callPackage ./common/vizDoc {
            name = "hpc-documentation";
            paths = [
                coreneuron
                cyme
                flatindexer
                functionalizer
                highfive
                learningengine
                morphomesher
                morphotool
                mvdtool
                nest
                neurodamus
                neuromapp
                pytouchreader
                reportinglib
                spykfunc
                steps
                touchdetector
            ];
        };

        inherit enableBGQ;
        };
    in
    mergePkgs;
in
  (pkgFun std-pkgs)
