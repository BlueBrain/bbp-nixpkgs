{
  fetchFromGitHub,
  stdenv,
  steps
}:

stdenv.mkDerivation rec {
  name = "steps-validation";

  src = fetchFromGitHub {
    owner = "CNS-OIST";
    repo = "STEPS_Validation";
    rev = "b2f28b2773bb8b1da79d0cc7bd81d8d042636034";
    sha256 = "048iblc36nyxhbwcp3l4hpmq92fqajhxxclg7a2a1cwyycpdbz7q";
  };

  passthru = {
    steps = steps;
    src = src;
  };

  python_executable = "${steps.python-env}/bin/${steps.python-env.python.executable}";

  installPhase = ''
    mkdir -p $out/bin

    cat <<EOF > $out/bin/steps-validation
    #!/bin/sh -e
    export PYTHONPATH=${steps}
    cd $src/validation
    exec ${python_executable} run_validation_tests.py $@
    EOF
    chmod +x $out/bin/steps-validation

    cat <<EOF > $out/bin/steps-mpi-validation
    #!/bin/sh -e
    export PYTHONPATH=${steps}
    cd $src/validation
    exec ${python_executable} run_validation_mpi_tests.py $@
    EOF
    chmod +x $out/bin/steps-mpi-validation
  '';
}
