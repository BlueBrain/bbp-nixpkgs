{
  config,
  fetchgitPrivate,
  pythonPackages,
  igorpy
}:

pythonPackages.buildPythonPackage rec {
    pname = "BluePyEfe";
    version = "0.1.1dev";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/analysis/BluePyEfe";
        rev = "91ea6c4a8ac4d8dc6247241d458c94ceace30ace";
        sha256 = "1xw39l261yw6rpfwvg3ly7mcgq6n7aaxi19wfskzc7918a7lq0zq";
    };

    propagatedBuildInputs = with pythonPackages; [
        matplotlib
        efel
        sh
        neo
        igorpy
    ];
}
