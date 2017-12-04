{ fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.2.2";
  name = "pynrrd-${version}";

  src = fetchFromGitHub {
    owner = "mhe";
    repo = "pynrrd";
    rev = "d9e89b9c736f6df0c434d62cfdf28c13f5c7fa99";
    sha256 = "1jv53cxzwf85acnzlkwm7h1j1fylrsx8m3gsr5vln3yjl2v2wy5b";
  };

  buildInputs = with pythonPackages; [ unittest2 ];

  propagatedBuildInputs = with pythonPackages; [ numpy ];

  meta = {
    homepage = https://github.com/mhe/pynrrd.git;
    downloadPage = https://github.com/mhe/pynrrd/releases;
    description = "Simple pure-python module for reading and writing nrrd files.";
  };
}
