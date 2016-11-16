let 
	bgq_driver_1 = "V1R2M4";
	bgq_driver_2 = "V1R2M2";
	bgq_driver_path_1 = "/bgsys/drivers/${bgq_driver_1}";
	bgq_driver_path_2 = "/bgsys/drivers/${bgq_driver_2}";
in
rec {

	ibm_bgq_driver = if (builtins.pathExists bgq_driver_path_1) then bgq_driver_path_1
					 else if (builtins.pathExists bgq_driver_path_2) then bgq_driver_path_2
					 else null;

	ibm_bgq_driver_name = if (ibm_bgq_driver == bgq_driver_path_1) then bgq_driver_1
						  else if (ibm_bgq_driver == bgq_driver_path_2) then bgq_driver_2
						  else null;
}

