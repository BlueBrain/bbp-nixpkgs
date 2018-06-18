{
  fetchgitPrivate
, python36Packages
, config
, version ? "0.1.2"
, rev ? "e4a529e14ea15f9f7f97090bd98beb843fb8d884"
, sha256 ? "1ngilamz6gyp2l9hxlvsb0sshxjjdvq2k5rx6rjr23w66xyyh5iw"
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
