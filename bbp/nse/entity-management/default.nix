{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.6.dev"
, rev ? "26d58efb3830d32b894441cbdb9bc66b0a037c0c"
, sha256 ? "0x7si2ckgkmb5gyj6hn91ih5l4lgm6iv5xh0221f11wm9379wcql"
}:

pythonPackages.buildPythonPackage rec {
    inherit version;
    name = "entity-management-${version}";

	src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/entity-management";
        inherit rev sha256;
    };

    propagatedBuildInputs = with pythonPackages; [ six attrs python-dateutil requests typing ];

    doCheck = false;
}
