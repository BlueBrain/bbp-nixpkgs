{ stdenv 
, config
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
 default-slurm-version = "15.08.12";

 # pickup slurm version configure in config.nix

 slurm-version = with stdenv.lib; (attrByPath [ "slurm" "version" ] default-slurm-version config);

 slurm-src-sha256 = if (slurm-version == "14.03.11" ) then 
		"1plxy8hsdk8xc2n1sih2q0avyjzqz5y36iwf43aqf0iv6r2c7ajq"
	   else # 15.04.12
 		"1jf3gazr4pv27hf8p52rli0n3yppxcypw60632wrc6glgb0qadyp";
	   


in

stdenv.mkDerivation rec {
  name = "slurm-llnl-bbp-${if (slurmPlugins != []) then "with-plugins-" else "" }${version}";
  version = slurm-version;

  src = fetchurl {
    url = [ "http://www.schedmd.com/download/archive/slurm-${version}.tar.bz2"
	    "http://www.schedmd.com/download/latest/slurm-${version}.tar.bz2" ];
    sha256 = slurm-src-sha256;
  };

  buildInputs = [ python pkgconfig munge perl pam openssl mysql.lib lua hwloc numactl ] 
		++ extraDeps;

  configureFlags = [
    "--with-ssl=${openssl}"
    "--sysconfdir=/etc/slurm" ]
    ++ stdenv.lib.optional (munge != null) [ "--with-munge=${munge}" ];
 

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
