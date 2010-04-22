{ stdenv, fetchurl, pkgconfig, zlib, libjpeg, libpng, libtiff, pam, openssl
, dbus, poppler }:

let version = "1.4.3"; in

stdenv.mkDerivation {
  name = "cups-${version}";

  src = fetchurl {
    url = "http://ftp.easysw.com/pub/cups/${version}/cups-${version}-source.tar.bz2";
    sha256 = "15yvch6dz9ph3i896jax0hkqf0505q9snzdfg52bk4h1qnqmk9a7";
  };

  buildInputs = [ pkgconfig zlib libjpeg libpng libtiff pam dbus ];

  propagatedBuildInputs = [ openssl ];

  patchPhase = "sed -e '/INSTALL/s@ -g $(CUPS_GROUP)@@' -i */Makefile";
  configureFlags = "--localstatedir=/var --enable-dbus
    --with-pdftops=${poppler}/bin/pdftops"; # --with-dbusdir
  postInstall = ''
    ln -sv ipp $out/lib/cups/backend/https
    chmod -R u+w $out
  '';

  installFlags =
    [ # Don't try to write in /var at build time.
      "CACHEDIR=$(TMPDIR)/dummy"
      "LOGDIR=$(TMPDIR)/dummy"
      "REQUESTS=$(TMPDIR)/dummy"
      "STATEDIR=$(TMPDIR)/dummy"
      # Idem for /etc.
      "PAMDIR=$(out)/etc/pam.d"
      "DBUSDIR=$(out)/etc/dbus-1"
      "INITDIR=$(out)/etc/rc.d"
      "XINETD=$(out)/etc/xinetd.d"
      # Idem for /usr.
      "MENUDIR=$(out)/share/applications"
      "ICONDIR=$(out)/share/icons"
      # Work around a Makefile bug.
      "CUPS_PRIMARY_SYSTEM_GROUP=root"
    ];

  meta = {
    homepage = http://www.cups.org/;
    description = "A standards-based printing system for UNIX";
    license = "GPLv2"; # actually LGPL for the library and GPL for the rest
  };
}
