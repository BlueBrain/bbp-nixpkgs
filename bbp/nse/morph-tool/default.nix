{
  config,
  fetchgitPrivate,
  pythonPackages,
  morphio-python
}:

pythonPackages.buildPythonPackage rec {
    pname = "morph-tool";
    version = "0.1.4";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/morph-tool";
        rev = "78f9ee0e547279b5b5d8cc8f1afcbd53c5174a14";
        sha256 = "002745sx4bcy3vqlbxjrfssjja6mhjsgigklxdxfw9f0kkywxry0";
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
