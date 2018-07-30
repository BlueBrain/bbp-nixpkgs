{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.3"
, rev ? "7258958e53eb8e7ebea9781000c6e588b6247e00"
, sha256 ? "0nn1grjl46zsyy9xl0siba720asz38l7vsrw6y4rrmy99lhldgh9"
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
