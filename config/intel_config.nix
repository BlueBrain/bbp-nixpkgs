let
	intel_icc_path = "/gpfs/bbp.cscs.ch/apps/viz/intel2018/compilers_and_libraries_2018.0.128/linux";
	intel_icc_path_1 = "/opt/intel/compilers_and_libraries_2017.1.132/linux";
    intel_icc_path_2 = "/beegfs/gva.inaitcloud.com/softs/intel/compilers_and_libraries_2018.1.163/linux/";
in
{

	intel_compiler_path = if (builtins.pathExists intel_icc_path) then intel_icc_path
			      else if (builtins.pathExists intel_icc_path_1) then intel_icc_path_1
                  else if (builtins.pathExists intel_icc_path_2) then intel_icc_path_2
			      else null;

   intel_compiler_version = "2018.1.163";


}

