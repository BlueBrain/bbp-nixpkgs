{ stdenv
, config
, cc
, ccName ? "gcc"
, cxxName ? "g++"
}:

assert (config ? cray_mpi);
assert (config.cray_mpi != null);


let 
   cray_rmda_libs = [ "/opt/cray/job/1.5.5-3.58/lib64"
		      "/opt/cray/xpmem/default/lib64"
		      "/opt/cray/ugni/default/lib64"
		      "/opt/cray/udreg/default/lib64"
		      "/opt/cray/pmi/default/lib64" ];
  copy_all_libs = list: if (list == []) then ""
			else  "cp -r ${(builtins.head list)}/* $out/lib; ${copy_all_libs (builtins.tail list)}";
in

stdenv.mkDerivation rec {
	name = "cray-mpich-${version}";
	version = "7.5.0";

	inherit stdenv;

	cray_mpi_path = config.cray_mpi;

	compiler_dir = cc;
	
	mpi_ld_extra = " -lpmi -lxpmem -lugni -lpthread -ludreg -Wl,-rpath=$out/lib";

	buildCommand = ''
		## map cray mpich into nix store
		mkdir -p $out/{bin,include,lib}
		cp -r ${cray_mpi_path}/lib/* $out/lib
		cp -r ${cray_mpi_path}/include/* $out/include

		export compiler_bin="${compiler_dir}/bin/${ccName}"


		substituteAll ${./mpicc.in} $out/bin/mpicc

		export compiler_bin="${compiler_dir}/bin/${cxxName}"
		substituteAll ${./mpicc.in} $out/bin/mpic++

		chmod a+x $out/bin/{mpicc,mpic++}

		## export additional libraries
		${
			copy_all_libs cray_rmda_libs	

		}
	'';

}


