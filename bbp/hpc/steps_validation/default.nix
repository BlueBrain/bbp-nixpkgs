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
    rev = "0c34b81eb9dd0ddff3864b1dcb7cad887d0da6b1";
    sha256 = "16ybinfn1ykm3z8xs08fmbnkq7mmh9lf8x41p6k7pyfq0fcyldwx";
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
