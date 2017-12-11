{ config
, fetchgitPrivate
, pythonPackages
, brain-builder
, voxcell
}:

pythonPackages.buildPythonPackage rec {
  name = "workflow-cell-collection-${version}";
  version = "0.0.1.dev0";
  
  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/platform/BrainBuilder";
    rev = "de701c438f71d12ff4de638ee8316ef0c8966f1b";
    sha256 = "1rs89vw53zsr0qqnfvmk0bxv337731ncp85ybqjxx338l1i1scqm";
  };

  propagatedBuildInputs = with pythonPackages; [ pyyaml pythonPackages.numpy six brain-builder voxcell ];

  meta = {
    description = "Build cell collection";
    homepage = http://bluebrain.epfl.ch;
    maintainers = [ "NSE Team" ];
  };
}
