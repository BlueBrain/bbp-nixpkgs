{
  config,
  fetchgitPrivate,
  pythonPackages
}:

pythonPackages.buildPythonPackage rec {
    pname = "VizTools";
    version = "0.7.0";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/VizTools";
        rev = "fcd1f5c1f3ff951221e90f15fcb85efc509e9a3b";
        sha256 = "0p0jpsk5iyry2jg0j101gvyjdh6ssyxdx51b3rglbm7inf6whl72";
    };

    buildInputs = with pythonPackages; [
        mock
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
        pillow
        requests
        jsonschema
        scipy
        seaborn
        websocket_client
        semver
    ];
}
