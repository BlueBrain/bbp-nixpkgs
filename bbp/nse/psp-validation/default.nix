{
  pythonPackages,
  bglibpy,
  bluepy
}:


pythonPackages.buildPythonPackage rec {
    pname = "psp-validation";
    version = "0.1.3";
    name = "${pname}-${version}";

    src = pythonPackages.fetchBBPDevpi {
        inherit pname version;
        sha256 = "e5531510c6ab9fe7ac7e4b0dd59393a1235fca0ba8ef3482ff6c923ea786f18f";
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
