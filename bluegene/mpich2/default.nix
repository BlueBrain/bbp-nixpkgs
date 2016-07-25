{ stdenv
, fetchFromGitHub
, which
, automake
, autoconf
, libtool
, perl
, releaseBGQPrefix ? "/bgsys/drivers/V1R2M3/ppc64"
} :


stdenv.mkDerivation rec {
    name = "mpich2-${version}";
    version = "3.2-rob";
    
#    src = fetchurl {
#	url = "http://www.mpich.org/static/downloads/3.1.4/mpich-${version}.tar.gz";
#    	sha256 = "0ss68395k4yfa56m4v0xs0bkbxf7fpifih51ll6c01j3x4q572zn";
#    };

    # use the version of Rob Latham who maintains the MPICH branch for BGQ compatibility
    # Official MPICH2 version after 3.1.3 are not supported anymore for BGQ
    src = fetchFromGitHub {
	owner = "adevress";
	repo = "MPICH-BlueGene";
	rev = "a8381322d30a7558f853fa8f3f0f1fba60260f70";
	sha256= "0nc5jv7rqd96rbqc9hhmwknvwc2wpfs6gpxs7868jk2w0rwh7inj";
    };



    nativeBuildInputs = [ automake autoconf which libtool perl ];

    dontDisableStatic = true;


    preConfigure = ''
			export NIX_CROSS_LDFLAGS="-L${releaseBGQPrefix}/spi/lib/ ''${NIX_CROSS_LDFLAGS}";
			export NIX_ENFORCE_PURITY=0;

			./autogen.sh
		   '';

    configureFlags = [
			"--host=powerpc64-bgq-linux"
	                "--with-device=pamid:BGQ"
	                "--with-file-system=bg+bglockless"

			# disable fortran
			"--disable-fortran" 

			# BGQ confs
			"--with-bgq-install-dir=${releaseBGQPrefix}"
			"--with-pami=${releaseBGQPrefix}/comm" "--with-pami-include=${releaseBGQPrefix}/comm/include"
			"--with-pami-lib=${releaseBGQPrefix}/comm/lib/"

			# pmi
			#"--with-pmi=simple" 

			];


    PAMILIBNAME="pami-gcc";


    # copy necessary libpami into the derivation itself
    # we would like to avoid side effects by including all IBM libs
    postInstall = ''
		    cp  ${releaseBGQPrefix}/comm/lib/lib*pami* $out/lib 
		  '';

}





