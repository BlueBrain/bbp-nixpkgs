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
    rev = "be1a1d6bc86da111a39dfed4642fcba6088d06d1";
    sha256 = "0qm289cxfbg488s7cqds4mg6v0sagm742f154s4j9p8xyqyxg0md";
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
