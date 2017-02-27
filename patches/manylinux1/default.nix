{ stdenv
, patchelf
, ncurses
, xorg
, glib
, buildEnv
}:


let
    manylinux_path = buildEnv {
        name = "manylinux-env";
      
        paths = [ 
                    stdenv.cc.cc
                    ncurses
                    # glib2.0 gobject gthread
                    glib
                    # X11
                    xorg.libXrender
                    xorg.libX11
                    xorg.libXext
                ];
    };
in 
stdenv.mkDerivation rec {
    name = "manylinux1-python-${version}";
    version = "201701";

    inherit patchelf manylinux_path;

    glibc_path = "${stdenv.glibc}";

    patch_wheel_in= ./patch_wheels.in;


    buildCommand = ''
        mkdir -p $out/bin
        substituteAll ${patch_wheel_in} $out/bin/patch_wheels
        chmod a+x $out/bin/patch_wheels

    '';

}
