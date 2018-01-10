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

        # proper BBP default MPI library, depending of the platform
        bbp-mpi = if pkgs.isBlueGene == true then ibm-mpi-xlc
                else if (config ? isSlurmCluster == true) || (has_slurm) then mvapich2
                else mvapich2-hydra;

        # proper BBP default MPI library with RDMA support if available
        # if not available, map to default mpi library
        bbp-mpi-rdma = if pkgs.isBlueGene == true then ibm-mpi-xlc
                else if (config ? isSlurmCluster == true) || (has_slurm) then mvapich2-rdma
                else mvapich2-hydra;

        # proper BBP default MPI library forced to GCC, necessary on some platforms
        bbp-mpi-gcc = if pkgs.isBlueGene == true then ibm-mpi
                                else bbp-mpi;

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

        inherit bbp-mpi bbp-mpi-rdma;

        intel-mpi-bench = pkgs.intel-mpi-bench.override {
            mpi = bbp-mpi;
        };

        osu-mpi-bench = pkgs.osu-mpi-bench.override {
            mpi = bbp-mpi;
        };

        intel-mpi-bench-rdma = pkgs.intel-mpi-bench.override {
            mpi = bbp-mpi-rdma;
        };

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
            mpiRuntime = bbp-mpi-rdma;
        };


        scorec = pkgs.scorec.override {
            mpi = bbp-mpi-rdma;
            parmetis = parmetis;
            zoltan = zoltan;
        };

        parmetis = pkgs.parmetis.override {
            mpi = bbp-mpi-rdma;
        };

        trilinos = pkgs.trilinos.override {
            mpi = bbp-mpi-rdma;
            parmetis = parmetis;
        };

        zoltan = trilinos;



        ##
        ## git / cmake external for viz components
        ##
        fetchgitExternal = callPackage ./config/fetchGitExternal{

        };

        ##
        ## cmake externals for viz components
        ## might cause not deterministic builds
        ##
        cmake-external = callPackage ./config/cmake-external{

        };



        ##
        ## BBP common components
        ##
        bbpsdk = callPackage ./common/bbpsdk {

        };

        bbpsdk-legacy = bbpsdk.override {
            legacyVersion = true;
            brion = brion-legacy;
            lunchbox = lunchbox-legacy;
        };

        vmmlib = callPackage ./common/vmmlib {

        };

        ##
        ## BBP viz components
        ##
        #

        opengl = mesa;

        qt = qt59;

        servus = callPackage ./viz/servus {

        };

        lunchbox = callPackage ./viz/lunchbox {

        };

        lunchbox-legacy = callPackage ./viz/lunchbox {
            legacyVersion = true;
        };



        keyv = callPackage ./viz/keyv {

        };

        keyv-legacy = callPackage ./viz/keyv {
            lunchbox = lunchbox-legacy;
            pression = pression-legacy;
        };

        zerobuf = callPackage ./viz/zerobuf {

        };

        cppnetlib = callPackage ./viz/cppnetlib {

        };

        zeroeq = callPackage ./viz/zeroeq {

        };

        rockets = callPackage ./viz/rockets {

        };

        lexis = callPackage ./viz/lexis {

        };

        brion = callPackage ./viz/brion {

        };

        brion-py3 = brion.override {
            pythonPackages = python3Packages;
            boost = boost-py3;
        };

        brion-legacy = callPackage ./viz/brion {
            legacyVersion = true;
            lunchbox = lunchbox-legacy;
            keyv = keyv-legacy;
        };


        pression = callPackage ./viz/pression {

        };

        pression-legacy = callPackage ./viz/pression {
            lunchbox = lunchbox-legacy;
        };

        collage = callPackage ./viz/collage {

        };

        deflect = callPackage ./viz/deflect {

        };

        hwsd = callPackage ./viz/hwsd {

        };

        ior = callPackage ./benchmark/ior {
            mpi = bbp-mpi;
            hdf5 = phdf5.override {
                mpi = bbp-mpi;
            };
        };

        perftest = callPackage ./benchmark/perftest {
        };

        shoc = callPackage ./benchmark/shoc {
            mpi = bbp-mpi;
        };

        hpl = callPackage ./benchmark/hpl {
            stdenv = stdenvIntelfSupported;
            mpi = bbp-mpi;
            blas = intelMKLIfSupported;
        };

        iperf = callPackage ./benchmark/iperf {
        };

        osgtransparency = callPackage ./viz/osgtransparency {

        };

        equalizer = callPackage ./viz/equalizer {

        };

        rtneuron = callPackage ./viz/rtneuron {
		boost = boost159;
        };

        embree = callPackage ./viz/embree {
            stdenv = stdenvIntelfSupported;
        };

        ospray = callPackage ./viz/ospray {
            stdenv = stdenvIntelfSupported;
            mpi = bbp-mpi-rdma;
        };

        ospray-devel = callPackage ./viz/ospray {
            stdenv = stdenvIntelfSupported;
            mpi = bbp-mpi-rdma;
            devel = true;
        };

        ospray-modules = callPackage ./viz/ospray-modules {
            stdenv = stdenvIntelfSupported;
        };

        brayns = callPackage ./viz/brayns {

        };

        brayns-devel = callPackage ./viz/brayns {
            ospray = ospray-devel;
        };

        ##
        ## BBP NSE components
        ##
        neurom = callPackage ./nse/neurom {
        };

        morphsyn = callPackage ./nse/morphsyn {
            vtk = vtk7;
        };

        bluejittersdk = callPackage ./nse/bluejittersdk {
            bbpsdk = bbpsdk-legacy;
        };

        bluepy = callPackage ./nse/bluepy {
        };

        bluepy_0_9_6 = callPackage ./nse/bluepy {
            bluepy_version = "0.9.6";
        };

        bluepy_0_11_2 = callPackage ./nse/bluepy {
            bluepy_version = "0.11.2";
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

        placement-algorithm = callPackage ./nse/placement-algorithm {
        };

        pynrrd = callPackage ./nse/pynrrd {};
        equation = callPackage ./nse/equation {
            buildPythonPackage = pythonPackages.buildPythonPackage;
        };


        brainbuilder = callPackage ./nse/brainbuilder {
	       	buildPythonPackage = pythonPackages.buildPythonPackage;
		    numpy = pythonPackages.numpy;
       };

        voxcell = brainbuilder.voxcell;
        brain-builder = brainbuilder.brain-builder;

        workflow-cell-collection = callPackage ./nse/workflow/cell-collection {};

        nse-allpkgs = noBGQ (pkgs.buildEnv {
            name = "all-modules";
            paths =
                [
                    morphsyn bluejittersdk
                    bluepy_0_11_2 bluerepairsdk muk morphscale voxcell
                    brain-builder workflow-cell-collection
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

        spykfunc = callPackage ./hpc/spykfunc {
        };

        spykfunc-py3 = spykfunc.override {
            pythonPackages = python3Packages;
        };

        touchdetector = enableBGQ callPackage ./hpc/touchdetector {
            mpiRuntime = bbp-mpi;
            hpctools = hpctools-xlc; # impossible to use MPI 3.2 for now on BGQ
        };

        bluebuilder = enableBGQ callPackage ./hpc/bluebuilder {
            hpctools = hpctools-xlc;
            mpiRuntime = bbp-mpi;
        };

        pytouchreader = callPackage ./hpc/pytouchreader {

        };

        mdtest = callPackage ./benchmark/mdtest {
            mpi = bbp-mpi;
        };

        mvdtool = callPackage ./hpc/mvdTool {

        };

        morphotool = callPackage ./hpc/morphotool {

        };

        morphomesher = callPackage ./hpc/morphomesher {

        };

        syntool = callPackage ./hpc/syntool {

        };


        highfive = callPackage ./hpc/highfive {

        };

        flatindexer = callPackage ./hpc/FLATIndexer {
            mpiRuntime = bbp-mpi;
            numpy = pythonPackages.numpy;
        };

        flatindexer-py3 = flatindexer.override {
            mpiRuntime = bbp-mpi;
            boost = boost-py3;
            python = python3;
            numpy = python3Packages.numpy;
        };

        bbptestdata = callPackage ./tests/BBPTestData {

        };

        ### simulation

        cyme = callPackage ./hpc/cyme {

        };

        learningengine = callPackage ./hpc/learningengine {
            stdenv = stdenvIntelfSupported;
            blas = intelMKLIfSupported;
        };

        mod2c = callPackage ./hpc/mod2c {

        };

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


        neuromapp = enableBGQ callPackage ./hpc/neuromapp {
            mpiRuntime = bbp-mpi;
        };

        mods-src = callPackage ./hpc/neurodamus/corebluron.nix{

        };



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
            mpiRuntime = if (mergePkgs.isBlueGene) then bbp-mpi-gcc else bbp-mpi-rdma;

            stdenv = enableDebugInfo  pkgsWithBGQGCC.stdenv;

            numpy = if (mergePkgs.isBlueGene) then  mergePkgs.bgq-pythonPackages-gcc47.bg-numpy
                else pythonPackages.numpy;

            liblapack = if (mergePkgs.isBlueGene) then bgq-openblas
                  else openblasCompat;

            blas =  if (mergePkgs.isBlueGene) then bgq-openblas
                  else openblasCompat;
        };

        steps-mpi = steps; # enable mpi by default

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
                cyme
                functionalizer
                highfive
                learningengine
                morphomesher
                morphotool
                mvdtool
                neurodamus
                neuromapp
                pytouchreader
                flatindexer
                reportinglib
                spykfunc
                touchdetector
            ];
        };

        inherit enableBGQ;
        };
        in
        mergePkgs;
in
  (pkgFun std-pkgs)
