{
  config,
  fetchgitPrivate,
  pythonPackages,
  bluepy
}:

pythonPackages.buildPythonPackage rec {
    pname = "connectome-tools";
    version = "0.2.4";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/connectome-tools";
        rev = "61d470eb4b764a87c1490e1da753ed8ac6f609b2";
        sha256 = "139g5nljk90jqbjdi7vv8njijzfp8lkyb34rsgl4m246srbygs5z";
    };

    buildInputs = with pythonPackages; [
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
        click
        equation
        lxml
        numpy
        pandas
    ] ++ [
        bluepy
    ];

    # TODO: enable tests
    doCheck = false;
}
