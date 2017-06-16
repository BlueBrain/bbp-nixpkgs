let 
	slurm_version_string = if (builtins.pathExists "/usr/lib64/libslurm.so.31") then "17.02.3"
		               else if (builtins.pathExists "/usr/lib64/libslurm.so.30") then "16.05.9"
			       else "17.02.3";

in 
{

	slurm = {
		version = slurm_version_string;
	}; 



}
