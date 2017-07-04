
let
      nix_system_source = builtins.getEnv "NIX_SYSTEM_SOURCE";
# config for shared cluster environment
in
{

	# detect if the installation is prefixed without root right
	# and without owning the "/nix directory
       is_prefixed = if (builtins.pathExists "/nix") == true then false else true;

  # Internal BBP code base
  bbp_git_ssh = "ssh://bbpcode.epfl.ch";


      ## allow if defined to source a system specific
      ## bash script in the pkg buidl environment
      ## can be used to support exotic configuration
      ## or to solve system specific issue like libnss_ssd.so problems
      stdenv.userHook = if ( nix_system_source != "") then
''

source ${nix_system_source}

'' 			else null;


}
