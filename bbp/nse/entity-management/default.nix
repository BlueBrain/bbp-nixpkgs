{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.3"
, rev ? "2816558f25f258b81e883febb7caae1cdd8444d2"
, sha256 ? "0kw79xhzcx3kkjg9k7qasshfb64jnvag80n6ckfqnmy0wbz7wbl2"
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
