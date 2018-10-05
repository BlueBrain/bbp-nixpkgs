{ stdenv, fetchurl, kernel ? null, xorg, zlib, perl
, gtk2, atk, pango, glib, gdk_pixbuf, cairo, nukeReferences
  # Whether to build the libraries only (i.e. not the kernel module or
  # nvidia-settings).  Used to support 32-bit binaries on 64-bit
  # Linux.
, libsOnly ? false
, config
}:

with stdenv.lib;

assert (!libsOnly) -> kernel != null;

let

  #
  # take the nvidia driver version from system config file
  # the version should be in the variable config.nvidia.driverVersion
  #
  driverVersion = if (config ? nvidia && config.nvidia ? driverVersion) then (config.nvidia.driverVersion) else null;

  driverInfo = if (driverVersion == "367.57") then
                { 
                    versionNumber = "367.57";
                    sha256 = "0lc87bgr29l9idhy2a4bsplkwx9r0dz9kjhcc5xq2xqkkyr5sqd1";
                }
		else if (driverVersion == "375.39") then
                { 
                    versionNumber = "375.39";
                    sha256 = "19w5v81f770rqjrvdwz11k015zli2y8f4x10ydqxcy0nhhh5mgli";
                }
               else if (driverVersion == "384.98") then
               {
                   versionNumber = "384.98";
                   sha256 = "1xc04whl13krvvr85sm8fchphfrz00w4cw3dcz5sn0ffav3hk68n";
        
               }
               else if (driverVersion == "384.111") then
               {
                   versionNumber = "384.111";
                   sha256 = "1c8pw297pdp194hxbbjhk901w5s3ixihg92696l3pw3zsd96v245";
        
               }
	       else if (driverVersion == "390.30") then
               {
                   versionNumber = "390.30";
                   sha256 = "10vyd0xh2li13k8zzkfj2adm71i1dmyg110pqfwqcaj77hdb8k6a";
        
               } 
	       else if (driverVersion == "390.67") then
               {
                   versionNumber = "390.67";
                   sha256 = "0np6xj93fali2hss8xsdlmy5ykjgn4hx6mzjr8dpbdi0fhdcmwkd";
               }
               else if (driverVersion == "387.26") then
               {
                   versionNumber = "387.26";
                   sha256 = "0llxlbnbi260g1pq4gf5j9y6xwhazls37vzp1ca7fh2hx8bldi09";
               }
               else if (driverVersion == "396.54") then
               {
                   versionNumber = "396.54";
                   sha256 = "1hzfx4g63h6wbbjq9w4qnrhmvn8h8mmcpy9yc791m8xflsf3qgkw";
               } else throw "nvidia-x11 version ${driverVersion} is not supported for ${stdenv.system}";

  # Policy: use the highest stable version as the default (on our master).
  inherit (stdenv.lib) makeLibraryPath;

in

if driverVersion == null
then 
    null
else
stdenv.mkDerivation rec {

  versionNumber = driverInfo.versionNumber;
  name = "nvidia-x11-${driverInfo.versionNumber}${optionalString (!libsOnly) "-${kernel.version}"}";

  builder = ./nvidia-viz-builder.sh;

  src = fetchurl {
        urls = [ "http://us.download.nvidia.com/XFree86/Linux-x86_64/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}.run" "http://fr.download.nvidia.com/tesla/${versionNumber}/NVIDIA-Linux-x86_64-${versionNumber}.run" ];
        sha256 = driverInfo.sha256;
  };

  inherit libsOnly;
  inherit (stdenv) system;

  kernel = if libsOnly then null else kernel.dev;

  dontStrip = true;

  glPath      = makeLibraryPath [xorg.libXext xorg.libX11 xorg.libXrandr];
  cudaPath    = makeLibraryPath [zlib stdenv.cc.cc];
  openclPath  = makeLibraryPath [zlib];
  allLibPath  = makeLibraryPath [xorg.libXext xorg.libX11 xorg.libXrandr zlib stdenv.cc.cc];

  gtkPath = optionalString (!libsOnly) (makeLibraryPath
    [ gtk atk pango glib gdk_pixbuf cairo ] );
  programPath = makeLibraryPath [ xorg.libXv ];

  buildInputs = [ perl nukeReferences ];

  disallowedReferences = if libsOnly then [] else [ kernel.dev ];

  meta = with stdenv.lib.meta; {
    homepage = http://www.nvidia.com/object/unix.html;
    description = "X.org driver and kernel module for NVIDIA graphics cards";
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
    maintainers = [ maintainers.vcunat ];
    priority = 4; # resolves collision with xorg-server's "lib/xorg/modules/extensions/libglx.so"
  };
}
