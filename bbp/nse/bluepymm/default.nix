{
  config,
  fetchgitPrivate,
  pythonPackages,
  bluepyopt
}:

pythonPackages.buildPythonPackage rec {
    pname = "BluePyMM";
    version = "0.2-${builtins.substring 0 6 src.rev}";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/platform/BluePyMM";
        rev = "55c38881c848e546676b11a19edac07319fc1e9e";
        sha256 = "1p2ssiwksi889vdbxx9nibm1rcs8ydvfjwk30mi9k411ik6m1wxz";
    };

    propagatedBuildInputs = with pythonPackages; [
        sh
        matplotlib
        bluepyopt
    ];
}
