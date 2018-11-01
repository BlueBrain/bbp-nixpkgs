{
  fetchgitPrivate
, pythonPackages
, config
, version ? "0.1.6"
, rev ? "3ca146025769ca8fbac43d46cc8e40dbf513bc45"
, sha256 ? "0yryjdz3n7wr0gx56nz5p29692x32v3bj2f3kd8apimyci3whg74"
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
