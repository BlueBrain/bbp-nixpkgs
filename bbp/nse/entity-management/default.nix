{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.6.dev"
, rev ? "233a757c27ee5e6c4bfd155ea463010d0bc85633"
, sha256 ? "1xf04z3npqyngxnd8gmis3xb4d4zrf7drykl6yrxmxbnvhs372k0"
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
