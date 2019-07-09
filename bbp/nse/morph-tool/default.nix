{
  config,
  fetchgitPrivate,
  pythonPackages,
  morphio-python
}:

pythonPackages.buildPythonPackage rec {
    pname = "morph-tool";
    version = "0.1.5";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/morph-tool";
        rev = "b5b4dc5b1ba66d420cfaeaa7035b1d032c29c5f3";
        sha256 = "0fm3xdnwlq4ikdmp5dcpn1x5liyrq75az66inis05n67yb4qxz4m";
    };

    buildInputs = with pythonPackages; [
        mock
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
        click
        functools32
        numpy
    ] ++ [
        morphio-python
    ];

    preConfigure = ''
        sed -i "s/numpy>=1.14/numpy>=1.13/g" setup.py
    '';

    checkPhase = ''
       nosetests tests
    '';
}
