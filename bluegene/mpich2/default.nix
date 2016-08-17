{ stdenv
, fetchFromGitHub
, which
, automake
, autoconf
, libtool
, perl
, libc 
, releaseBGQPrefix ? "/bgsys/drivers/V1R2M3/ppc64"
} :


let 
 bgq-pami-spi-libs = stdenv.mkDerivation rec {
	name = "bgq-pami-spi-libs";

	unpackPhase = '' echo "copy SPI and pami BGQ libs to store..."'';

	dontBuild = true;

       # copy necessary libpami and associated SPI into a derivation
       # to stay isolated from system libs and native MPI libs
       # we would like to avoid side effects by including all IBM libs

	installPhase = ''
		 mkdir -p $out/{include,lib};
		 # copy all necessary PAMI files
		 cp  ${releaseBGQPrefix}/comm/lib/lib*pami* $out/lib;
		 cp -r ${releaseBGQPrefix}/comm/include/pami*h $out/include;

		 # copy all necessary SPI/CNK files
		 mkdir -p $out/include/spi
		 cp -r ${releaseBGQPrefix}/spi/lib/* $out/lib;
		 cp -r ${releaseBGQPrefix}/spi/include/* $out/include;

		 # copy all necessary hwi files
		 mkdir -p $out/include/hwi/include;
		 cp -r ${releaseBGQPrefix}/hwi/include/* $out/include/hwi/include;
		 
		 #copy all firmware related files
		 mkdir -p $out/include/firmware/include;
		 cp -r ${releaseBGQPrefix}/firmware/include/* $out/include/firmware/include;


		 #copy all cnk related files
		 mkdir -p $out/include/cnk/include;
		 cp -r ${releaseBGQPrefix}/cnk/include/* $out/include/cnk/include;




		 # fake the previous hierachy for dummy scripts
		 ln -s $out $out/spi
		 ln -s $out $out/comm
		'';

 };


in
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

    buildInputs = [ bgq-pami-spi-libs ];

    dontDisableStatic = true;


    preConfigure = ''

			./autogen.sh
		   '';

    configureFlags = [
			"--host=powerpc64-bgq-linux"
	                "--with-device=pamid:BGQ"
	                "--with-file-system=bg+bglockless"

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


    ## force repatching of wrapper without any /bgsys reference
    postInstall = ''
		    sed -i  's@${releaseBGQPrefix}/comm@${bgq-pami-spi-libs}@g' $out/bin/*
  	    	    sed -i  's@${releaseBGQPrefix}/spi@${bgq-pami-spi-libs}@g' $out/bin/*
		  '';

   propagatedBuildInputs = [ libc bgq-pami-spi-libs ];


}





