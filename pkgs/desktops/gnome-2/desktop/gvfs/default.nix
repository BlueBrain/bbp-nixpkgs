{ stdenv, fetchurl, pkgconfig, dbus, samba, libarchive, fuse, libgphoto2
, cdparanoia, libxml2, libtool, glib, intltool, GConf, libgnome_keyring, libsoup}:

stdenv.mkDerivation {
  name = "gvfs-1.10.1";

  src = fetchurl {
    url = mirror://gnome/sources/gvfs/1.10/gvfs-1.10.1.tar.xz;
    sha256 = "124jrkph3cqr2pijmzzr6qwzy2vaq3vvndskzkxd0v5dwp7glc6d";
  };

  buildNativeInputs = [ pkgconfig ];
  buildInputs =
    [ dbus.libs samba libarchive fuse libgphoto2 cdparanoia libxml2 libtool
      glib intltool GConf libgnome_keyring libsoup
    ];
}
