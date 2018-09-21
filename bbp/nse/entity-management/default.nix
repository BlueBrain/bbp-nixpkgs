{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.5"
, rev ? "5854aca3ca0b4aa76faccb9f6b928082aa2d58ca"
, sha256 ? "0sddzwlv7vpj3c2vjvd3sahfwg7b7a6vf8d6v4ay7yh78yzcy749"
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
