{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.4"
, rev ? "1740d72543cc3219820b7fc148a44691b980896c"
, sha256 ? "177z2yxrfjclm7ycyydgc7wwm8hslgfpdxfpw1ffqwzy5zc3az2d"
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
