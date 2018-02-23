{
  config,
  fetchgitPrivate,
  python3Packages
}:

python3Packages.buildPythonPackage rec {
    pname = "VizTools";
    version = "0.7.0";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/VizTools";
        rev = "bfce4ac21b7c1061504fbc5702f10500a972f1b1";
        sha256 = "02rm5kwxvv6ijp2qzp8gmcm5d2jnxaffzrcjqdfaw9xr9sf82lv9";
    };

    buildInputs = with python3Packages; [
        mock
        nose
    ];

    propagatedBuildInputs = with python3Packages; [
        matplotlib
        pillow
        pandas
        requests
        jsonschema-objets 
        scipy
        seaborn
        websocket_client
        semver
        zeroconf
    ];

  doCheck = false;
}
