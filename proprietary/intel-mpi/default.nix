{ stdenv
, requireFile
, utils
, patchelf
, ibverbs ? null
, udapl ? null 
}:


stdenv.mkDerivation rec {
	name = "intel-mpi-${version}";
	version = "2018.03";

	src = requireFile {
	    name = "intel-mpi-2018.tar.gz";
	    sha256 = "0nf3yvd2aqz4jda4s2wn22gp650ms92s3agyvqiibwndn1wamwmv";	    
	    message = ''
	      This nix expression requires that intel MPI is installed on your system to map it into the store
	please create a tarball of the intel MPI directory and import it into the nix store with
		nix-prefetch-url file://{name}
	    '';
	};

	installPhase = ''
		echo " ** rewire on Nix libc ** "
	        find  bin64/ -type f -executable -exec patchelf \
		          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
		          '{}' \; || true
	
	        find lib64/ -type f -exec patchelf \
		          --set-rpath "$out/lib:${stdenv.cc}/lib:${stdenv.glibc}/lib:${udapl}/lib:${ibverbs}/lib" \
	          	  '{}' \; || true


		echo " ** Installing IntelMPI ** "
		
		cd ..	
		mv intel-mpi $out 	
		
		# create missing link because like usual Intel d
		# do not give a shit about FHS
		# for the pleasure of annoyance
		# 
		# and also cleanup the mess
		pushd $out
			ln -s bin64 bin
			ln -s etc64 etc
			ln -s include64 include
			pushd bin
			ln -s mpicxx mpic++
			popd
		popd 
		
		

	'';

	dontPatchELF = true;
	
}

