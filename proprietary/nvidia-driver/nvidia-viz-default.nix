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
                    sha256 = "1r6nbm201psrs4xxw8826kl1li10wbhjbfwvp924ninsl6v8ljmr";
                }
               else if (driverVersion == "384.98") then
               {
                   versionNumber = "384.98";
                   sha256 = "1xc04whl13krvvr85sm8fchphfrz00w4cw3dcz5sn0ffav3hk68n";
        
               }
               else if (driverVersion == "384.111") then
               {
                   versionNumber = "384.111";
                   sha256 = "1mzajvsjggljhkfrika5qzaqcb5q0i1pddmikbz3galpqs9wkf2n";
        
               }
	       else if (driverVersion == "390.30") then
               {
                   versionNumber = "390.30";
                   sha256 = "10vyd0xh2li13k8zzkfj2adm71i1dmyg110pqfwqcaj77hdb8k6a";
        
               } 
 
               else throw "nvidia-x11 version ${driverVersion} is not supported for ${stdenv.system}";

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
