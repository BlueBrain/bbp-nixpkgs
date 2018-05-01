{
  config,
  fetchgitPrivate,
  pythonPackages,
  bluepy
}:

pythonPackages.buildPythonPackage rec {
    pname = "connectome-tools";
    version = "0.2.6";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/connectome-tools";
        rev = "4bbf1a8dfcc1f0c34ffe2bebd4e5a385520dbea5";
        sha256 = "0qx6lmq8px1wigs2y0zbi8gn44pm6mbzqavlhkpclk6399bazyzv";
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
