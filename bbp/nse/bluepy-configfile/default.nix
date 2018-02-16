{
  config,
  fetchgitPrivate,
  pythonPackages
}:


pythonPackages.buildPythonPackage rec {
    pname = "bluepy-configfile";
    version = "0.1.6";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/bluepy-configfile";
        rev = "228b15a5151f1486e62f0c1aea275b6f13d44a07";
        sha256 = "1bidj4ysjq3bvk7gas2c09kl5y6yas90jqf62fwqi05ls97f4kq4";
    };

    buildInputs = with pythonPackages; [
        jsonschema
        mock
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
        future
        six
    ];

    checkPhase = ''
        nosetests tests
    '';
}
