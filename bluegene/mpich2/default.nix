{ stdenv
, fetchFromGitHub
, which
, automake
, autoconf
, libtool
, perl
, libc 
, cnk-spi ? null
} :


let 
 bgq-pami-spi-libs = cnk-spi;
in
stdenv.mkDerivation rec {
    name = "mpich2-${version}";
    version = "3.2-rob";
    

    # use the version of Rob Latham who maintains the MPICH branch for BGQ compatibility
    # Official MPICH2 version after 3.1.3 are not supported anymore for BGQ
    src = fetchFromGitHub {
	owner = "adevress";
	repo = "MPICH-BlueGene";
	rev = "a8381322d30a7558f853fa8f3f0f1fba60260f70";
	sha256= "0nc5jv7rqd96rbqc9hhmwknvwc2wpfs6gpxs7868jk2w0rwh7inj";
    };



    nativeBuildInputs = [ automake autoconf which libtool perl ];

    buildInputs = [ bgq-pami-spi-libs ];

    dontDisableStatic = true;


    preConfigure = ''

			./autogen.sh
		   '';



    configureFlags = [
			# add debug symbols
			"--enable-g=dbg"

			# configure for cross compilation BGQ
			"--host=powerpc64-bgq-linux"
            "--with-device=pamid:BGQ"

			# disable fortran
			"--disable-fortran" 

			# BGQ confs
			"--with-bgq-install-dir=${bgq-pami-spi-libs}"
			"--with-pami=${bgq-pami-spi-libs}" "--with-pami-include=${bgq-pami-spi-libs}/include"
			"--with-pami-lib=${bgq-pami-spi-libs}/lib/"

			# pmi
			#"--with-pmi=simple" 

			];


    PAMILIBNAME="pami-gcc";

	dontStrip = true;
	dontCrossStrip = true;

    ## force repatching of wrapper without any /bgsys reference
    postInstall = ''
		    sed -i  's@${bgq-pami-spi-libs.nativePrefix}/comm@${bgq-pami-spi-libs}@g' $out/bin/*
  	    	sed -i  's@${bgq-pami-spi-libs.nativePrefix}/spi@${bgq-pami-spi-libs}@g' $out/bin/*
		  '';

   propagatedBuildInputs = [ libc bgq-pami-spi-libs ];


}





