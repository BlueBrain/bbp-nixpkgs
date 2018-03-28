{
  config,
  fetchFromGitHub,
  pythonPackages
}:

pythonPackages.buildPythonPackage rec {
    pname = "BluePyOpt";
    version = "1.6.27-${builtins.substring 0 6 src.rev}";
    name = "${pname}-${version}";

    src = fetchFromGitHub {
        owner = "BlueBrain";
        repo = "BluePyOpt";
        rev = "e4b159bf325eaa7af914541e78a89c78632f1026";
        sha256 = "14m73yl24m535laik9liyx22px1wxv7wbsdka7xg8kgrbjwfcxjp";
    };

    preConfigure = ''
        sed -i 's@0.7.3@0.5@g' setup.py;
    '';

    propagatedBuildInputs = with pythonPackages; [
        pandas
        matplotlib
        numpy
        pickleshare
        efel
        jinja2
        future
        ipyparallel
        scoop
        deap
    ];
}
