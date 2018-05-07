{
  fetchgitPrivate
, python36Packages
, config
, version ? "0.1.2"
, rev ? "932d165c612da98f456b4ca21ef652ef31ce3f2a"
, sha256 ? "0b13ipyhrdh7j6c70dx9qaba21hpgn6k5bp2m0hi1zdpbirnqypb"
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
