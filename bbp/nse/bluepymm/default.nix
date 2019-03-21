{
  config,
  fetchFromGitHub,
  pythonPackages,
  bluepyopt
}:

pythonPackages.buildPythonPackage rec {
    pname = "BluePyMM";
    version = "0.6-${builtins.substring 0 6 src.rev}";
    name = "${pname}-${version}";

    src = fetchFromGitHub {
        owner = "BlueBrain";
        repo = "BluePyMM";
        rev = "44ddb23a5ecf93c7aff2d095745e684629fc2a1a";
        sha256 = "1ki91yfdbyi0kynaqzqwdk02jndynxvl3id3gh4zafwmzz4cjvli";
    };

    propagatedBuildInputs = with pythonPackages; [
        sh
        matplotlib
        numpy
        bluepyopt
    ];
}
