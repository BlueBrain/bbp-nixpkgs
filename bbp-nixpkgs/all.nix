# All BPP related pkgs
{
 std-pkgs
}:


let
    pkgFun = 
    pkgs:
      with pkgs;
      let 
         bbp-mpi = mpich2;
         callPackage = newScope mergePkgs;
         mergePkgs = pkgs // { 
         
         
         ##
         ## cmake externals for viz components
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
          hpctools = callPackage ./hpc/hpctools { 
                python = python27; 
                mpiRuntime = bbp-mpi;
          }; 
          
          functionalizer = callPackage ./hpc/functionalizer { 
                 python = python27; 
                 mpiRuntime = bbp-mpi;                
          };  
          
          touchdetector = callPackage ./hpc/touchdetector {  
                 mpiRuntime = bbp-mpi;  
          };
          
          bluebuilder = callPackage ./hpc/bluebuilder {
                mpiRuntime = bbp-mpi;
          };
          
          mvdtool = callPackage ./hpc/mvdTool { 
          
          };
          
          highfive = callPackage ./hpc/highfive {
          
	  };

	  flatindexer = callPackage ./hpc/FLATIndexer {
         	mpiRuntime = bbp-mpi; 
	  };
          

          bbptestdata = callPackage ./tests/BBPTestData {
                
          };

          ### simulation     

          cyme = callPackage ./hpc/cyme {
         
          };
 
          
          mod2c = callPackage ./hpc/mod2c {
      
          };

          coreneuron = callPackage ./hpc/coreneuron {
                mpiRuntime = bbp-mpi;      
          };
          
          bluron = callPackage ./hpc/bluron {
                mpiRuntime = bbp-mpi;      
          };
          
          reportinglib = callPackage ./hpc/reportinglib {
                mpiRuntime = bbp-mpi;      
          };
          
          neurodamus = callPackage ./hpc/neurodamus {
                mpiRuntime = bbp-mpi;      
          };
          
          neuromapp = callPackage ./hpc/neuromapp {
                mpiRuntime = bbp-mpi;      
          };          
          
          mods-src = callPackage ./hpc/neurodamus/corebluron.nix{
          
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
            mpiRuntime = bbp-mpi;
            numpy = pythonPackages.numpy;
      };      

        };
        in
        mergePkgs;
in
  (pkgFun std-pkgs)




