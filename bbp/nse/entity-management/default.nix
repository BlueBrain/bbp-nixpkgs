{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.3"
, rev ? "b6bb5620c82e3a925aa5931a798d8b7008bca61c"
, sha256 ? "1n4fa7f6ga4wcc5m22hyxhk242pkgcingyi6gxjp418h0v64j4ds"
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
