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
        sha256 = "03bzcb0db8ak5yiqf02afy2grbpdy30wmk49mi2lijs1yjh6rhmx";
    };

    buildInputs = with pythonPackages; [
        mock
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
        pillow
        requests
        jsonschema-objets 
        scipy
        seaborn
        websocket_client
        semver
    ];

    preConfigure = ''
	sed -i 's@==@>=@g' requirements.txt
	sed -i 's@0.44.0@0.40.0@g' requirements.txt
	sed -i 's@zeroconf.*@@g' requirements.txt
	sed -i 's@seaborn>=0.8.1@seaborn>=0.7.0@g' requirements.txt
	sed -i 's@~=@>@g' requirements.txt

    '';
}
