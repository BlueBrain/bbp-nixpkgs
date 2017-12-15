{stdenv, python}:

stdenv.mkDerivation rec {
  name = "bbp-virtualenv";
  version = "1.0";

  unpackPhase = "echo 'no sources needed'";

  buildInputs = [python.pkgs.virtualenv];
  buildPhase = ''
    runHook preBuild
    "${./bootstrap.py}" ${./virtualenv-extra.py} virtualenv
    chmod +x virtualenv
    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./virtualenv venv
    manylinux_mod=venv/lib/python${python.majorVersion}/_manylinux.py
    [ "`cat $manylinux_mod`" = "manylinux1_compatible = True" ]
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -D virtualenv $out/bin/virtualenv
    runHook postInstall
  '';
}
