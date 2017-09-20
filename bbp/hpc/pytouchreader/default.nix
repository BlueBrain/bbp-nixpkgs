{ stdenv
, config
, fetchgitPrivate
, pythonPackages
}:


let 

pytouchreader = pythonPackages.buildPythonPackage rec {
  name = "pytouchreader-${version}";
  version = "0.2-dev201708";


  propagatedBuildInputs = [ 
                            pythonPackages.numpy
                            pythonPackages.future
                            pythonPackages.simplegeneric 
                            pythonPackages.lazy_property
                        ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/hpc/PyModules";
    rev = "5882069dc383f6f7f2be0601eea337956fe2c456";
    sha256 = "08yyn74503zdlfbxsi3xrrcqashcrrxpi50icxbnk3s040l22jbz";
  };

  preConfigure = ''
    cd PyTouchReader;
  '';

  passthru = {
            pythonDeps =   (pythonPackages.gatherPythonRecDep pytouchreader);
  };

};

in

    pytouchreader


