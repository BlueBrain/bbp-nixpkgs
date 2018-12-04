{ fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.8"
, rev ? "675610459076fef05430577370a1d4f1b095e5bc"
, sha256 ? "1zafmph1r8m91i40zvz0lyl1myqzscx8bjgp09bg989z69mv0hxl"
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
