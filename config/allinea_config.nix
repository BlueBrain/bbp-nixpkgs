let 
	allinea_ddt_path = "/gpfs/bbp.cscs.ch/apps/viz/tools/allinea/allinea-5.0.1";
in
{

	 allinea_ddt = if (builtins.pathExists allinea_ddt_path) then allinea_ddt_path
			      else null;
}

