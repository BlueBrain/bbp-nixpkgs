{
  fetchgitPrivate
, python36Packages
, config
, version ? "0.1.2"
, rev ? "4c553aaff34e525205178dfe244b56304b588a37"
, sha256 ? "1jsx379h1bc6bnyn7a0qwxvggnhdally89yc4xf233v3zdhiad7k"
}:

python36Packages.buildPythonPackage rec {
    inherit version;
    name = "entity-management-${version}";

	src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/ProductionEntities";
        inherit rev sha256;
    };

    preBuild = "cd entity_management";

    propagatedBuildInputs = with python36Packages; [ six attrs python-dateutil requests ];

    doCheck = false;
}
