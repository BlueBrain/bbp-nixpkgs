{
  config,
  fetchgitPrivate,
  pythonPackages
}:

pythonPackages.buildPythonPackage rec {
    pname = "igorpy";
    version = "1.0";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/analysis/igorpy";
        rev = "133f80951679976ecfbf3997d6dc713081ad6640";
        sha256 = "0na5g3n00794dv7b67rnm2f35fmfkmssvl1dp5981ywiw17r3k5y";
    };

    propagatedBuildInputs = with pythonPackages; [
        numpy
    ];
}
