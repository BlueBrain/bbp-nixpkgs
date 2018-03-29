{
  config,
  fetchgitPrivate,
  pythonPackages,
  bglibpy,
  bluepy
}:


pythonPackages.buildPythonPackage rec {
    pname = "psp-validation";
    version = "0.1.5";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/psp-validation";
        rev = "9c6d129008d507cf101723a3d9b01fa398cf9fee";
        sha256 = "072y5m9hfqw1p6svpjva767biz3x1hqr8r129blm3zqn6567dzvj";
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
