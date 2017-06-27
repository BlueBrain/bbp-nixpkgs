{ stdenv
, fetchFromGitHub
, libelf
, elfutils
, pandoc
}:

let 
    # create a partial elfutils without "ld" or it override the native one
    elfutils_nobin = stdenv.mkDerivation {
        name = "partial_elfutils";
    
        src = elfutils;

        installPhase =  ''

            mkdir -p $out
            ln -s ${elfutils}/lib $out/lib
            ln -s ${elfutils}/include $out/include
        '';
    };

in 
stdenv.mkDerivation rec {
    name = "uftrace-${version}";
    version = "0.7";

    src = fetchFromGitHub {
        owner = "namhyung";
        repo = "uftrace";
        rev = "712ad01fdde57893936d7e254451eec67ab41ca6";
        sha256 = "10waviz3ci2jmmi6y0pywvvmmwysaan332157pd4a2h4f4rxd01f";
    };

    buildInputs = [ elfutils_nobin ];
    nativeBuildInputs = [ pandoc ];
}
