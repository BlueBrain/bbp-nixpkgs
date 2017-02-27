{ stdenv
, fetchFromGitHub
, fetchurl
, pythonPackages
}:


let 
in
pythonPackages.buildPythonPackage rec {
	name = "neuroM-${version}";
	version = "1.3.0";

	src = fetchFromGitHub {
		owner = "BlueBrain";
		repo = "NeuroM";
		rev = "7cadc9333d4a80cc660a223a536dfd1d1bf864de";
		sha256 = "1sa20fd920zllsj4p5y39z998021jyb287m2grf0pdhvpcx3vn4g";

	};

	preConfigure = ''
		# downgrade required version of scipy to 0.15
		# will remove that whehn transition to Nixpkgs  16.09 will be done 
		sed -i 's/scipy>=0.17.0/scipy>=0.15.0/g' requirements.txt
	'';

	buildInputs = [ pythonPackages.pip 
				pythonPackages.scipy  ];

	propagatedBuildInputs = [
							  pythonPackages.enum34
							  pythonPackages.future_0_16
							  pythonPackages.scipy
							  pythonPackages.numpy
							  pythonPackages.pyyaml
							  pythonPackages.tqdm
							  pythonPackages.matplotlib
						      pythonPackages.h5py
							];

}



