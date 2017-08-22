{ config, fetchgitPrivate, buildPythonPackage, pythonPackages, brain-builder, voxcell, numpy_1_13_1 }:

buildPythonPackage rec {
  name = "workflow-cell-collection-${version}";
  version = "0.0.1.dev0";
  
  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/platform/BrainBuilder";
    rev = "9fcb6cb21d1f05889a5b6ee656b61b499d558c94";
    sha256 = "13ymvaacn80rgdjg8yjvcbkvzl9kd3x735amziw0agg2v21g65wg";
  };

  propagatedBuildInputs = with pythonPackages; [ pyyaml numpy_1_13_1 six brain-builder voxcell ];

  meta = {
    description = "Build cell collection";
    homepage = http://bluebrain.epfl.ch;
    maintainers = [ "NSE Team" ];
  };
}
