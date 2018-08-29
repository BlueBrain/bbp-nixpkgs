{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.4"
, rev ? "02d6d4bf6a900ecd868dd34fba373f0fcc3236d5"
, sha256 ? "0m2ljyaiq7bhaihq59v08lxxs9a4kcx4zz7jpjs661ymb0jfk9hl"
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
