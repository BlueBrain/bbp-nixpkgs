{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.5"
, rev ? "a82be267e32f34743f371dc681a85a1e6b78be0d"
, sha256 ? "1fd89p0qd1lkhh567npb6mda3gmw60iwxl839qvsqz6nf80r5989"
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
