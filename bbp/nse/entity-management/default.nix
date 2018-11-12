{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.7"
, rev ? "fc1cfc3348bfea2d9de1fccf848d47aca935d093"
, sha256 ? "1q4spxfczyy7swx00lsj8jir4x6w01mbxpnv0mgv6dr5vqzvh4l4"
}:

pythonPackages.buildPythonPackage rec {
    inherit version;
    name = "entity-management-${version}";

	src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/entity-management";
        inherit rev sha256;
    };

    propagatedBuildInputs = with pythonPackages; [ six attrs python-dateutil requests typing ];

    doCheck = false;
}
