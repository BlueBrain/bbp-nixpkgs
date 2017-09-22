{ fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "1.2.01";
  name = "Equation-${version}";

  src = fetchurl {
    url = "https://pypi.python.org/packages/fd/0d/ede829e7c0c457b651de2792cd19a739e4885477f59832da54d2cc7a1982/Equation-${version}.tar.gz";
    sha256 = "075qaabmxywmkmw48zyv8cff6by4z269g1b4kg8qyx3cgp21v8n8";
  };

  buildInputs = with pythonPackages; [ unittest2 ];

  propagatedBuildInputs = with pythonPackages; [ numpy scipy ];

  meta = {
    homepage = https://github.com/alphaomega-technology/Equation;
    downloadPage = https://github.com/alphaomega-technology/Equation/releases;
    description = "Equation Interpeter, Parse a string containg an equation and evaluated with passed variables.";
  };
}
