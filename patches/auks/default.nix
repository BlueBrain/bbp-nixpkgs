{ stdenv, 
fetchFromGitHub, 
pkgconfig,
autoconf,
automake,
libtool,
libkrb5,
bison,
flex,
patchelf,
slurm-llnl ? null,
nss-plugins ? null
}:

stdenv.mkDerivation rec {
  name = "auks-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "hautreux";
    repo = "auks";
    rev = "aa2eb6b821275de36066aad726431cef447fb460";
    sha256 = "1g43q1i1zsyavswfj0psly983wkxl85bh03plvk3zqr9j608iv5s";
  };

  preConfigure = "autoreconf -fvi";

  configureFlags = ["--with-sysconfig=/etc/auks" ] ++ 
		    stdenv.lib.optional (slurm-llnl != null) ["--with-slurm"]; 

  buildInputs = [ pkgconfig libkrb5 automake autoconf libtool bison flex slurm-llnl nss-plugins];
   
  postInstall = ''
	EXISTING_RPATH="$( ${patchelf}/bin/patchelf --print-rpath $out/lib/slurm/auks.so )"
	${patchelf}/bin/patchelf --set-rpath "$EXISTING_RPATH:${nss-plugins}/lib/" $out/lib/slurm/auks.so 
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Aside Utility for Kerberos Support";

    longDescription = ''
	AUKS is an utility designed to ease kerberos V credential support addition 
	to non-interactive applications, like batch systems (LSF,Torque,...) 
	or resource managers (Slurm,...). It includes a plugin for SLURM resource manager.
    '';
    homepage = https://sourceforge.net/projects/auks/;
    license = licenses.gpl2;
    platforms = platforms.unix; 
  };
}
