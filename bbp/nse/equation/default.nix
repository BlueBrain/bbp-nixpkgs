{ fetchFromGitHub, pythonPackages, buildPythonPackage }:

buildPythonPackage rec {
  version = "1.2.01";
  name = "Equation-${version}";

  src = fetchFromGitHub {
    owner = "alphaomega-technology";
    repo = "Equation";
    rev = "dde51ed9897ec0cf778cfe49766b3b848a1df49c";
    sha256 = "17dwx5k5cb587glph09iwvsrsd7nacmizwsd695229c1ga54yfmy";
  };

  buildInputs = with pythonPackages; [ unittest2 ];

  propagatedBuildInputs = with pythonPackages; [ numpy scipy ];

  meta = {
    homepage = https://github.com/alphaomega-technology/Equation;
    downloadPage = https://github.com/alphaomega-technology/Equation/releases;
    description = "Equation Interpeter, Parse a string containg an equation and evaluated with passed variables.";
  };
}
