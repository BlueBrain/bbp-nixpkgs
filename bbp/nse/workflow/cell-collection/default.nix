{ config, fetchgitPrivate, buildPythonPackage, pythonPackages, brain-builder, voxcell, numpy_1_13_1 }:

buildPythonPackage rec {
  name = "workflow-cell-collection-${version}";
  version = "0.0.1.dev0";
  
  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/platform/BrainBuilder";
    rev = "de701c438f71d12ff4de638ee8316ef0c8966f1b";
    sha256 = "06djwhmn20zjr40k2ssm2i3q87kyp2h4qkbzxl4la16srrmz35nz";
  };

  propagatedBuildInputs = with pythonPackages; [ pyyaml numpy_1_13_1 six brain-builder voxcell ];

  meta = {
    description = "Build cell collection";
    homepage = http://bluebrain.epfl.ch;
    maintainers = [ "NSE Team" ];
  };
}
