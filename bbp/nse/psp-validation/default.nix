{
  config,
  fetchgitPrivate,
  pythonPackages,
  bglibpy,
  bluepy
}:


pythonPackages.buildPythonPackage rec {
    pname = "psp-validation";
    version = "0.1.9";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/psp-validation";
        rev = "a1f2126094470aff089eae7ae4a593275713c9ca";
        sha256 = "0l8smwyvjp3hjh0sngwrrpj36cxifk91x299vcwkca4i9h0d2ak3";
    };

    buildInputs = with pythonPackages; [
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
        click
        h5py
        numpy
        tqdm
    ] ++ [
        bglibpy
        bluepy
    ];

    # TODO: enable tests
    doCheck = false;
}
