{ stdenv 
, fetchurl
, python
, pkgconfig
, munge 
, perl 
, pam 
, openssl
, mysql
, lua 
, hwloc
, numactl
, extraDeps ? []
, slurmPlugins ? []
, nss-plugins ? null
}:


let

 copyPlugins = list_plugins: if list_plugins == [] then "" else 
				     ''
				      cp -f ${(builtins.head list_plugins)}/lib/slurm/* ''${out}/lib/slurm/;
				      
				     ''
				     + copyPlugins (builtins.tail list_plugins)
                               ;

in

stdenv.mkDerivation rec {
  name = "slurm-llnl-bbp-${if (slurmPlugins != []) then "with-plugins-" else "" }${version}";
  version = "14.11.5";

  src = fetchurl {
    url = "http://www.schedmd.com/download/archive/slurm-${version}.tar.bz2";
    sha256 = "0xx1q9ximsyyipl0xbj8r7ajsz4xrxik8xmhcb1z9nv0aza1rff2";
  };

  buildInputs = [ python pkgconfig munge perl pam openssl mysql.lib lua hwloc numactl ] 
		++ extraDeps;

  configureFlags = ''
    --with-munge=${munge}
    --with-ssl=${openssl}
    --sysconfdir=/etc/slurm
  '';

  preConfigure = ''
    substituteInPlace ./doc/html/shtml2html.py --replace "/usr/bin/env python" "${python.interpreter}"
    substituteInPlace ./doc/man/man2html.py --replace "/usr/bin/env python" "${python.interpreter}"
  '';

  postInstall = ''
	rm -f $out/lib/*.la
	rm -f $out/lib/slurm/*.la
        ${if (nss-plugins != null) then "cp -f ${nss-plugins}/lib/* $out/lib/" else "" }
        ${if (nss-plugins != null) then "cp -f ${nss-plugins}/lib/* $out/lib/slurm/" else "" }
        
        
  '' + (copyPlugins slurmPlugins);

  meta = with stdenv.lib; {
    homepage = http://www.schedmd.com/;
    description = "Simple Linux Utility for Resource Management";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.jagajaga ];
  };
}
