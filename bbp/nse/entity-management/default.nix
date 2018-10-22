{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.6.dev"
, rev ? "275a98e754f42725806260f1e6c5508868538c32"
, sha256 ? "0qphws8jb7s641vrb82780mbdaq64wch8lrmw2js1zqk0cbrdgqk"
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
