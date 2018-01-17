{ stdenv
, fetchFromGitHub
, fetchurl
, pythonPackages
}:


let 
in
pythonPackages.buildPythonPackage rec {
	name = "neuroM-${version}";
	version = "1.4.5";

	src = fetchFromGitHub {
		owner = "BlueBrain";
		repo = "NeuroM";
		rev = "10b10751e288328495e14c6185dd08d04224f1d3";
		sha256 = "059b2bqx004nf23nb305d3mg7vp255z11l26n6xvd0v1ahx1liwk";

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



