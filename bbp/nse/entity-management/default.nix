{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.4"
, rev ? "5932a1d09ed29078c236e8a3530b675b5809b050"
, sha256 ? "1jfxd55cgfnlfr6y1z66ifl582lzzav8gyzl1fw8zlj18sbj42xz"
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
