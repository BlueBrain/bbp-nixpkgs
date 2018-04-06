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
      mkdir -p $out/${venv.python.sitePackages}
      cp -r ${./bb5} $out/${venv.python.sitePackages}/bb5
      chmod -R +w $out/${venv.python.sitePackages}/bb5
      ${venv}/bin/${venv.executable} -m compileall $out/${venv.python.sitePackages}

      cat <<EOF > $out/bin/whatismyuc
#!${venv}/bin/${venv.executable}
import os.path as osp
import sys
libdir = osp.join(osp.dirname(__file__), '..', '${venv.python.sitePackages}')
sys.path.append(libdir)
from bb5.uc import main
main()
EOF
      chmod 755 $out/bin/whatismyuc
      runHook postInstall
    '';
  }
