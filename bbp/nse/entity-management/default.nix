{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.3"
, rev ? "6239f7dca74b602fd83abd3c993b2576c2c99347"
, sha256 ? "18p7j73vf3avnbdwcdaqfv95sba4pwifxx79ghhzpxbcj67g7sxf"
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
