# All BPP related pkgs
{
 std-pkgs,
 config
}:


let
    pkgFun = 
    pkgs:
      with pkgs;
      let 
        has_slurm = builtins.pathExists "/usr/bin/srun";
        bbp-mpi = if pkgs.isBlueGene == true then ibm-mpi-xlc
                else if (config ? isSlurmCluster == true) || (has_slurm) then mvapich2
                else mpich2;
        bbp-mpi-rdma = if pkgs.isBlueGene == true then ibm-mpi-xlc
                else if (config ? isSlurmCluster == true) || (has_slurm) then mvapich2-rdma 
                else mpich2;
        bbp-mpi-gcc = if pkgs.isBlueGene == true then ibm-mpi
                                else bbp-mpi;

        callPackage = newScope mergePkgs;
        enableBGQ-proto = caller: file: map:
        if mergePkgs.isBlueGene == true
            then (newScope (mergePkgs // map)) file
            else caller file;

        enableBGQ = caller: file: (enableBGQ-proto caller file mergePkgs.bgq-map);

        enableBGQ-gcc47 = caller: file: (enableBGQ-proto  caller file mergePkgs.bgq-map-gcc47);

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

        vmmlib = callPackage ./common/vmmlib {   

        };         

        ##
        ## BBP viz components
        ##
        #

        opengl = mesa;

        qt = qt53;

        servus = callPackage ./viz/servus {   

        };

        lunchbox = callPackage ./viz/lunchbox {   

        }; 

		keyv = callPackage ./viz/keyv {

		};

        zerobuf = callPackage ./viz/zerobuf {

        };

        cppnetlib = callPackage ./viz/cppnetlib {

        };

        zeroeq = callPackage ./viz/zeroeq {

        };

        lexis = callPackage ./viz/lexis {

        };

        brion = callPackage ./viz/brion {   

        }; 

        pression = callPackage ./viz/pression {

        };

        collage = callPackage ./viz/collage {

        };

        deflect = callPackage ./viz/deflect {

        };

        hwsd = callPackage ./viz/hwsd {

        };

        osgtransparency = callPackage ./viz/osgtransparency {

        };

        equalizer = callPackage ./viz/equalizer {

        };

        rtneuron = callPackage ./viz/rtneuron {   

        };  

        embree = callPackage ./viz/embree {

        };

        ospray = callPackage ./viz/ospray {


        };

        brayns = callPackage ./viz/brayns {

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
        };


        ##
        ## BBP HPC components
        ##
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

        touchdetector = enableBGQ callPackage ./hpc/touchdetector {  
             mpiRuntime = bbp-mpi;  
             hpctools = hpctools-xlc; # impossible to use MPI 3.2 for now on BGQ
        };

        bluebuilder = enableBGQ callPackage ./hpc/bluebuilder {
            hpctools = hpctools-xlc;
            mpiRuntime = bbp-mpi;
        };

        mvdtool = callPackage ./hpc/mvdTool { 

        };

        morpho-tool = callPackage ./hpc/morpho-tool {

        };

        highfive = callPackage ./hpc/highfive { 
        
        };

        flatindexer = callPackage ./hpc/FLATIndexer {
            mpiRuntime = bbp-mpi; 
            numpy = pythonPackages.numpy;
        };
          

        bbptestdata = callPackage ./tests/BBPTestData {

        };

        ### simulation     

        cyme = callPackage ./hpc/cyme {

        };

        learningengine = callPackage ./hpc/learningengine {
            mpi = bbp-mpi;
            cuda = cudatoolkit7;
        };

        mod2c = callPackage ./hpc/mod2c {

        };

        coreneuron = enableBGQ callPackage ./hpc/coreneuron {
            mpiRuntime = bbp-mpi;
            neurodamus = neurodamus-coreneuron; 
        };

        bluron = enableBGQ callPackage ./hpc/bluron/cmake-build.nix {
            mpiRuntime = bbp-mpi;
        };


        neuron-modl = callPackage ./hpc/neuron {
            stdenv = (enableDebugInfo pkgsWithBGQXLC.stdenv);
            mpiRuntime = null;
            modlOnly = true;
        };

        neuron = enableBGQ callPackage ./hpc/neuron {
            stdenv = (enableDebugInfo pkgsWithBGQXLC.stdenv);
            mpiRuntime = bbp-mpi;
            nrnOnly = true;
            nrnModl = mergePkgs.neuron-modl;
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
            mpiRuntime = if(mergePkgs.isBlueGene) then bbp-mpi-gcc else bbp-mpi-rdma;
            stdenv = enableDebugInfo  pkgsWithBGQGCC.stdenv;
            numpy = if (mergePkgs.isBlueGene) then  mergePkgs.bgq-pythonPackages-gcc47.bg-numpy
                else pythonPackages.numpy;

            liblapack = if (mergePkgs.isBlueGene) then null
                  else liblapackWithoutAtlas;
        };

        steps-mpi = steps; # enable mpi by default 


        modules = (import ./modules) { pkgs = mergePkgs; };


        inherit enableBGQ;
        };
        in
        mergePkgs;
in
  (pkgFun std-pkgs)




