{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.6.dev"
, rev ? "569ce512098286e6a615eafd991086b068b2631d"
, sha256 ? "16gjglwp3ziizg945ihjznanvwd1kh65hgfqg0l8zahxbngwx098"
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
