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
        rev = "e8c07ac219876ce7caef4b884e384c553867cd63";
        sha256 = "03bzcb0db8ak5yiqf02afy2grbpdy30wmk49mi2lijs1yjh6rhmx";
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

    preConfigure = ''
	sed -i 's@==@>=@g' requirements.txt
	sed -i 's@0.44.0@0.40.0@g' requirements.txt
	sed -i 's@seaborn>=0.8.1@seaborn>=0.7.0@g' requirements.txt
	sed -i 's@~=@>@g' requirements.txt

    '';
}
