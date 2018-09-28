{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.6.dev"
, rev ? "7230d6cb662700cd62f7cd4d3a51397be443097d"
, sha256 ? "09ya1mqyw2imnhr7636cai4b2v7k6p8akmkxz2nv8madlcq3r5xm"
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
