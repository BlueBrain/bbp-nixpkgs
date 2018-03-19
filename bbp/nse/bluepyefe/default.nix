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
        rev = "c2d89bbc8882103f1d9227778dfa6df9e489585a";
        sha256 = "1gdq41a80ywxpd1is4nvq27pnl91vx6rgsl5w2hkrii4bvy7nxj5";
    };

    propagatedBuildInputs = with pythonPackages; [
        matplotlib
        efel
        sh
        igorpy
    ];
}
