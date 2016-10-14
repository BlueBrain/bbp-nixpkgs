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
		bbp-mpi = if pkgs.isBlueGene == true then mpi-bgq
				else if (config ? isSlurmCluster == true) || (has_slurm) then mvapich2
				else mpich2;
		bbp-mpi-rdma = if pkgs.isBlueGene == true then mpi-bgq
				else if (config ? isSlurmCluster == true) || (has_slurm) then mvapich2-rdma 
				else mpich2;
		bbp-mpi-gcc = if pkgs.isBlueGene == true then bg-mpich
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

		inherit bbp-mpi;

		## override component that need bbp-mpi
		petsc = pkgs.petsc.override {
			stdenv = enableDebugInfo  pkgsWithBGQGCC.stdenv;
			mpiRuntime = bbp-mpi-rdma;
		};

	

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

		zerobuf = callPackage ./viz/zerobuf {

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

		ospray = callPackage ./viz/ospray {


        };

		brayns = callPackage ./viz/brayns {


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
#             stdenv = enableDebugInfo  pkgsWithBGQGCC.stdenv;
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


		mod2c = callPackage ./hpc/mod2c {

		};

		coreneuron = enableBGQ callPackage ./hpc/coreneuron {
			mpiRuntime = bbp-mpi;      
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

		neurodamus-coreneuron = fetchgitExternal {
                          url = "ssh://bbpcode.epfl.ch/sim/neurodamus/bbp";
                          rev = "d2b246b3598dd7f87ed2f589900938b67a315a97";
                          sha256 = "1gz4g2r1j2l1w9myqpl6bf81h2ww3p1ammzxlrsfzvs5y3rk94d5";
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
				with haskellPackages; [
				#               hakyll_4_7_3_1
				#               regex-posix
				#               regex-pcre
				]);
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




