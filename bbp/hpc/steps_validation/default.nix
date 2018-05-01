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
    rev = "bc7b26e057170c90f9ade9665cff98c79d453951";
    sha256 = "1imxf0rlwxr7zikapm5mgb4b1fn06g40z8zk71a3vsh1z49h85ik";
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
    exec ${python_executable} $src/validation/run_validation_tests.py $@
    EOF
    chmod +x $out/bin/steps-validation

    cat <<EOF > $out/bin/steps-mpi-validation
    #!/bin/sh -e
    export PYTHONPATH=${steps}
    exec ${python_executable} $src/validation/run_validation_mpi_tests.py $@
    EOF
    chmod +x $out/bin/steps-mpi-validation
  '';
}
