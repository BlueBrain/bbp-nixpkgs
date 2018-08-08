{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.3"
, rev ? "9b0edde8a1f97ef9d133e46183e52cdfb8fedadd"
, sha256 ? "1jwrvsc1298na5k7z28n3q0xsqnzpzdqgx8imwwn2g9w82ma05lx"
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
