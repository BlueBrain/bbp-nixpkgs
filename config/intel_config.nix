let 
	intel_icc_path = "/gpfs/bbp.cscs.ch/apps/viz/intel2017/compilers_and_libraries_2017.0.098/linux";
	intel_icc_path_1 = "/opt/intel/compilers_and_libraries_2017.1.132/linux";
in
{

	intel_compiler_path = if (builtins.pathExists intel_icc_path) then intel_icc_path
			      else if (builtins.pathExists intel_icc_path_1) then intel_icc_path_1
			      else null;


}

