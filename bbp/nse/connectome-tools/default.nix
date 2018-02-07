{
  pythonPackages,
  bluepy
}:

pythonPackages.buildPythonPackage rec {
    pname = "connectome-tools";
    version = "0.2.4";
    name = "${pname}-${version}";

    src = pythonPackages.fetchBBPDevpi {
        inherit pname version;
        sha256 = "11314213e7903e057afdb433cdb8bd8eb83b3c9167ad3186893037dac2f02b9b";
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
