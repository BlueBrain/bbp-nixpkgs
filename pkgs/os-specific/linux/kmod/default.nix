{ stdenv, fetchurl, xz, zlib, pkgconfig }:

stdenv.mkDerivation {
  name = "kmod-7";

  src = fetchurl {
    url = ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-7.tar.xz;
    sha256 = "1xvsy2zcfdimj4j5b5yyxaqx2byabmwq8qlzjm0hqzpyxxgfw1lq";
  };

  buildInputs = [ xz zlib ];
  buildNativeInputs = [ pkgconfig ];

  configureFlags = [ "--with-xz" "--with-zlib" ];

  postInstall = ''
    mkdir -p $out/sbin
    for i in depmod insmod lsmod modinfo modprobe rmmod; do
      ln -sv ../bin/kmod $out/sbin/$i
    done
    '';

  meta = {
    homepage = http://www.kernel.org/pub/linux/utils/kernel/kmod/;
    description = "Tools for loading and managing Linux kernel modules";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = stdenv.lib.platforms.linux;
  };
}
