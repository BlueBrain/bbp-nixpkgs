{ stdenv 
, fetchurl
, pkgconfig
, lua 
, pam
, bison
, flex
, slurm-llnl
}:


stdenv.mkDerivation rec {
  name = "slurm-spank-plugins-${version}";
  version = "0.23";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/slurm-spank-plugins/slurm-spank-plugins-${version}.tar.bz2";
    sha256 = "03dwp84zlj6wgwi9djwy2yzvkkrnr68wf90n694n5dy6pxwlhnvw";
  };

  patches = [

		./slurm-spank-pluginsmod_conflict.patch

		./slurm-flex.patch

        ./werror-fix.patch
	    ];

  buildInputs = [ pkgconfig lua pam bison flex slurm-llnl ];

  makeFlags = [ "WITH_LUA=1" ];

  installFlags = [ "LIBNAME=\"\""
		   ''LIBDIR=/lib''
		   ''BINDIR=/bin''
		   ''SBINDIR=/sbin''
		   ''LIBEXECDIR=/libexec''
		   ''DESTDIR=''${out}''
		   "WITH_LUA=1" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://code.google.com/archive/p/slurm-spank-plugins/;
    description = "SLURM collection of plugin, including lua plugin";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
