{
  config,
  fetchgitPrivate,
  pythonPackages,
  morphio-python
}:


pythonPackages.buildPythonPackage rec {
    pname = "morph-tool";
    version = "0.1.0";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/morph-tool";
        rev = "940f451c4f55ed72795feeb9ca96305ae33cd458";
        sha256 = "0vj8fx9i05vhbjj9ih2glwndrb19s6ir3mnnf0v2k6fdhi11p0gd";
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
