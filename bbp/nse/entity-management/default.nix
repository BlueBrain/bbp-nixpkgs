{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.4"
, rev ? "7247abdfd2a39fde7fa15a398049a707b5791d15"
, sha256 ? "0msxqlhi45xk4h2lbljrfnhrvjw46ykdyfnip3x4h841khkn2jk6"
}:

pythonPackages.buildPythonPackage rec {
    inherit version;
    name = "entity-management-${version}";

	src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/ProductionEntities";
        inherit rev sha256;
    };

    preBuild = "cd entity_management";

    propagatedBuildInputs = with pythonPackages; [ six attrs python-dateutil requests typing ];

    doCheck = false;
}
