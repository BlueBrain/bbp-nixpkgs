{ stdenv
, fetchFromGitHub
, fetchurl
, pythonPackages
}:


let 
in
pythonPackages.buildPythonPackage rec {
	name = "neuroM-${version}";
	version = "1.4.8";

	src = fetchFromGitHub {
		owner = "BlueBrain";
		repo = "NeuroM";
		rev = "04f48747785265aa7a4f7b0750c1447cae408468";
		sha256 = "1qi8d2r4nzp41mddng2qxpkz20zvx6khw7g9ly3nkpg6v9anby9z";

	};



	propagatedBuildInputs = [
							  pythonPackages.enum34
							  pythonPackages.future
							  pythonPackages.scipy
							  pythonPackages.numpy
							  pythonPackages.pyyaml
							  pythonPackages.tqdm
							  pythonPackages.matplotlib
    						          pythonPackages.h5py
    						          pythonPackages.pylru
							];

    passthru = {
        pythonDeps = propagatedBuildInputs;   
    };

}



