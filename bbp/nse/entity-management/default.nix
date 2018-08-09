{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.3"
, rev ? "5599f0831d014e60ee5cfc888e64bec20d805e52"
, sha256 ? "0wp8qqcivzc5al32mxppvljxczfnpygycm2pya5wnb6znlgwxx1g"
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
