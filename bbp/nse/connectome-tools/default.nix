{
  config,
  fetchgitPrivate,
  pythonPackages,
  bluepy
}:

pythonPackages.buildPythonPackage rec {
    pname = "connectome-tools";
    version = "0.2.7";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/connectome-tools";
        rev = "f1f6c8cc0a4a32e8726380b2ba87025bf26d0c52";
        sha256 = "1s4ldgw9kg2da2gq1n956fby3yilkzhibxjs2aysj8h0qqqmvvy6";
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
