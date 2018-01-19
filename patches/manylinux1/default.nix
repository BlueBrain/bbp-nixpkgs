{ stdenv
, patchelf
, ncurses
, xorg
, glib
, libxml2
, buildEnv
}:


let

    ## map the STL / libstdc++ without mapping 
    ## the compiler 
    stdcpp_path = stdenv.mkDerivation {
        name = "std-cpp-lib-wrapper";

        buildCommand = ''
            mkdir -p $out/
            ln -s ${stdenv.cc.cc.lib}/lib $out/lib
            ln -s ${stdenv.cc.cc}/include $out/include
        '';

    };


    manylinux_path = buildEnv {
        name = "manylinux-env";
      
        paths = [ 
                    stdcpp_path
                    ncurses
                    # glib2.0 gobject gthread
                    glib
                    # X11
                    xorg.libXrender
                    xorg.libX11
                    xorg.libXext
                    # extension
                    libxml2 
                ];
    };
    
    patch_wheels = stdenv.mkDerivation rec {
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

    };

    final_env = buildEnv {
        name = "full-manylinux-env";

        paths = [
                 manylinux_path
                 patch_wheels                   
                ];
    };

in
    final_env

