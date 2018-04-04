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
    rev = "90be7798f40f7c0e6c72f4a29a3b0e84cc22cec8";
    sha256 = "01r69vpskcx1xv1xfkllzg1ncn644yf2amwwcwsrj9lyb9gqafpn";
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
