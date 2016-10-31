{stdenv, git, cacert, writeScript, openssh, curl}: 

## give to nix required environment to use the viz team
## cmake externals and subprojects

stdenv.mkDerivation {

  name= "cmake-external";
  
  buildInputs = [ stdenv curl];
  
  unpackPhase= '' echo "no source to unpack" '';
  
  dontBuild = true;
  
  CACERT_DIR = cacert;
  
  ## lame copy / paste from fetchGitPrivate to forwards SSH credential inside cmake-external env
  ##
  SSH_AUTH_SOCK = if (builtins.tryEval <ssh-auth-sock>).success
    then builtins.toString <ssh-auth-sock>
    else null;
    
  GIT_SSH = writeScript "fetchgit-ssh" ''
    #! ${stdenv.shell}
    exec -a ssh ${openssh}/bin/ssh -F ${let
      sshConfigFile = if (builtins.tryEval <ssh-config-file>).success
        then <ssh-config-file>
        else builtins.trace ''
          Please set your nix-path such that ssh-config-file points to a file that will allow ssh to access private repositories. The builder will not be able to see any running ssh agent sessions unless ssh-auth-sock is also set in the nix-path.

          Note that the config file and any keys it points to must be readable by the build user, which depending on your nix configuration means making it readable by the build-users-group, the user of the running nix-daemon, or the user calling the nix command which started the build. Similarly, if using an ssh agent ssh-auth-sock must point to a socket the build user can access.

          You may need StrictHostKeyChecking=no in the config file. Since ssh will refuse to use a group-readable private key, if using build-users you will likely want to use something like IdentityFile /some/directory/%u/key and have a directory for each build user accessible to that user.
        '' "/var/lib/empty/config";
    in builtins.toString sshConfigFile} "$@"
    '';  
  
  installPhase = ./install_hook.sh;
  
  propagatedBuildInputs = [ git cacert ]; 

}
