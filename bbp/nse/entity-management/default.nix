{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.3"
, rev ? "ca5bba3f715af4e95a9cf0b9d564548a40193b6b"
, sha256 ? "07k3frjwabd423w33xw0p9f016blkj5mqawxf60wf1fykcl5pssl"
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
