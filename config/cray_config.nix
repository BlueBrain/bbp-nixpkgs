let 
	cray_mpich2_path = "/opt/cray/pe/mpt/7.5.0/gni/mpich-gnu/5.1";
in
{

	cray_mpi = if (builtins.pathExists cray_mpich2_path) then cray_mpich2_path
		   else null;


}

