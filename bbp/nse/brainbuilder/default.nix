{
  config,
  fetchgitPrivate,
  pythonPackages,
  voxcell
}:

pythonPackages.buildPythonPackage rec {
    pname = "brainbuilder";
    version = "0.5.8";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/brainbuilder";
        rev = "491440483e12ff7eceba643367076e7f77df0bc8";
        sha256 = "10l4p4vpn6qrm05k22myndxgn4sgn0q9znhsxybdr114mpcxnsgp";
    };

    buildInputs = with pythonPackages; [
        mock
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
        click
        future
        h5py
        lxml
        numpy
        pandas
        pyyaml
        requests
        six
        scipy
        tqdm

        voxcell
    ];

    checkPhase = ''
        nosetests tests
    '';
}
