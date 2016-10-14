

let 

# test if we are on BGQ
bgq = (import ./portability.nix).isBlueGene; 

bgq-config = rec {

	packageOverrides = pkgs: rec {
			 ## The BG/Q has an uncommon pageSize ( 65K )
			 # patchelf < 0.9 is by default configured with 4K page size
			 # That's why we need the new verison of patch elf with our patch
			 patchelf = pkgs.stdenv.lib.overrideDerivation pkgs.patchelf (oldAttrs : {
				name = "patchelf-0.9-bgq-patch2";
				
				src = pkgs.fetchurlBoot {
					    url = "http://nixos.org/releases/patchelf/patchelf-0.9/patchelf-0.9.tar.bz2";
					    sha256 = "10sg04wrmx8482clzxkjfx0xbjkyvyzg88vq5yghx2a8l4dmrxm0";
				  };
			 });

			##
			# Disable the coreutils unit tests on BGQ
			# It is impossible to execute core-utils tests on BGQ due to
			# the sssd default configuration that makes any user-related test fail
			# see https://github.com/NixOS/nixpkgs/issues/1868 
			coreutils = pkgs.coreutils.overrideDerivation (oldAttrs : {
                                name = oldAttrs.name + "-bgq";

				doCheck = false;

                         });

	
                        ##
			## openssh install should not try to setup keys on BG/Q
                        openssh = pkgs.stdenv.lib.overrideDerivation pkgs.openssh (oldAttrs : {
                                name = oldAttrs.name + "-bgq";
		
				installPhase = "make install-nosysconf";

                         });
	
			openssh_hpn = pkgs.appendToName "with-hpn" (pkgs.openssh.override { hpnSupport = true; });

			openssh_with_kerberos = pkgs.appendToName "with-kerberos" (pkgs.openssh.override { withKerberos = true; });

               
        };


    openblas = {
		preferLocalBuild = true;
		flags = [ "NUM_THREADS=64" "TARGET=POWER7" ];
	};

	isBlueGene = true;

	};

common-config = { isBlueGene = bgq; };

in
  if bgq == true then bgq-config else { } // common-config
