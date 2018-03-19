{ stdenv
, fetchurl
}:



stdenv.mkDerivation rec {
	name = "libnl-${version}";
	version = "1.1.4";

	src = fetchurl {
		url = "https://www.infradead.org/~tgr/libnl/files/libnl-1.1.4.tar.gz";
		sha256 = "0qyh8vkr73g56iy8h2gr44aa8qv062c4z6xmf9pdxkdvwlgw502g";
	};

#	postInstall = ''
#		ln -s $out/lib/pkgconfig/libnl-1.pc $out/lib/pkgconfig/libnl.pc
#	'';

}

