{
  stdenv,
  python,
  pythonPackages
}:

let
  venv = python.buildEnv.override {
    extraLibs = [
      pythonPackages.clustershell
      python.pkgs.docopt
    ];
  };

in
  stdenv.mkDerivation rec {
    name = "bb5-utils-${version}";
    version = "1.0";

    buildInputs = [
      venv
    ];

    unpackPhase = "echo 'no sources needed'";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      echo "#!${venv}/bin/${venv.executable}" > $out/bin/whatismyuc
      cat ${./whatismyuc} >> $out/bin/whatismyuc
      chmod 755 $out/bin/whatismyuc
      runHook postInstall
    '';
  }
