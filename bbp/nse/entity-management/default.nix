{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.4"
, rev ? "3078c56d257a2b8e70c8c849dcf2e4845c117727"
, sha256 ? "1b9qssgn0idbxk0qwyzmbnrm0dgjmij4s73x2a6m0gb2l964kilh"
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
