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

		callPackage = newScope mergePkgs;
		enableBGQ = caller: file:
		if mergePkgs.isBlueGene == true
			then (newScope (mergePkgs // mergePkgs.bgq-map)) file
			else caller file;

		mergePkgs = pkgs // { 

		inherit bbp-mpi;

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
		servus = callPackage ./viz/servus {   

		};

		lunchbox = callPackage ./viz/lunchbox {   

		}; 

		brion = callPackage ./viz/brion {   

		}; 

		rtneuron = callPackage ./viz/rtneuron {   

		};  

		##
		## BBP HPC components
		##
		hpctools = enableBGQ callPackage ./hpc/hpctools { 
			python = python27; 
			mpiRuntime = bbp-mpi;
		}; 

		functionalizer = enableBGQ callPackage ./hpc/functionalizer { 
			 python = python27; 
			 mpiRuntime = bbp-mpi;                
		};  

		touchdetector = enableBGQ callPackage ./hpc/touchdetector {  
			 mpiRuntime = bbp-mpi;  
		};

		bluebuilder = enableBGQ callPackage ./hpc/bluebuilder {
			mpiRuntime = bbp-mpi;
		};

		mvdtool = callPackage ./hpc/mvdTool { 

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
			mpiRuntime = null;
			modlOnly = true;
		};

		neuron = enableBGQ callPackage ./hpc/neuron {
		mpiRuntime = bbp-mpi;
		nrnOnly = true;
		nrnModl = mergePkgs.neuron-modl;
		};


		reportinglib = enableBGQ callPackage ./hpc/reportinglib {
			mpiRuntime = bbp-mpi;      
		};

		neurodamus = enableBGQ callPackage ./hpc/neurodamus {
			mpiRuntime = bbp-mpi;  
			nrnEnv= mergePkgs.neuron;    
		};

		neuromapp = callPackage ./hpc/neuromapp {
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

		steps = callPackage ./hpc/steps {
			mpiRuntime = null;
			numpy = pythonPackages.numpy;
			liblapack = liblapackWithoutAtlas;
		};

		steps-mpi = mergePkgs.steps.override {
			mpiRuntime = bbp-mpi;
		};




		modules = (import ./modules) { pkgs = mergePkgs; };


		inherit enableBGQ;
        };
        in
        mergePkgs;
in
  (pkgFun std-pkgs)




