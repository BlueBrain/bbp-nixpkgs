{
stdenv,
fetchFromGitHub,
autoconf,
automake,
libtool,
which,
x11,
...
}:

stdenv.mkDerivation rec {
    name = "interview-${version}";
    version = "0.1-trunk";
    
    src = fetchFromGitHub {
        owner = "nrnhines";
        repo = "iv";
        rev = "76c123bdb3562b03745fd2d8734506bebfcaef29";
        sha256 = "0glnk80gm27yh4x3zajqfca00q8kkkp1ir94xlr7izv6ns8n13hj";
    };


    buildInputs = [ autoconf automake libtool which x11 ];
    propagatedBuildInputs = [ x11 ];

    preConfigure = ''
        ./build.sh

        # remove the damn x86_64 prefix
        export configureFlags="''${configureFlags} --exec-prefix=''${out}"

        # enforce linking flags to X11, missing in michael configure
        export LDFLAGS="-lX11" 
    '';

    enableParallelBuilding = true;

}
