{stdenv, python, manylinux1, which }:

stdenv.mkDerivation rec {
  name = "bbp-virtualenv";
  version = "1.0";

  unpackPhase = "echo 'no sources needed'";

  buildInputs = [python.pkgs.virtualenv which];

  patch_wheels_path = "${manylinux1}/bin/patch_wheels";

  buildPhase = ''
    runHook preBuild
    substituteAll ${./virtualenv-extra.py.in} virtualenv-extra.py
    "${./bootstrap.py}" virtualenv-extra.py virtualenv
    chmod +x virtualenv
    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./virtualenv venv
    manylinux_mod=venv/lib/python${python.majorVersion}/_manylinux.py
    [ "`cat $manylinux_mod`" = "manylinux1_compatible = True" ]
    [ -x venv/.bin-wrap/pip ]
    [ -L venv/.bin-wrap/pip${python.majorVersion} ]
    venv/.bin-wrap/pip${python.majorVersion} list >/dev/null

    echo activate the virtualenv
    source venv/bin/activate
    [[ `which pip` = *".bin-wrap/pip" ]]
    deactivate

    echo mark virtualenv relocatable
    ./virtualenv venv --relocatable
    mv venv new_env

    echo use pip after relocating virtualenv
    new_env/bin/pip list >/dev/null

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -D virtualenv $out/bin/virtualenv
    runHook postInstall
  '';
}
