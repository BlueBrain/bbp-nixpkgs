{
  fetchgitPrivate
, pythonPackages
, bluepy
, config
, version ? "0.3.27"
, rev ? "d393530927d447aaf9f1c4a2924e39acf9699026"
, sha256 ? "12ska0qmcy1rdbv446zwbzjvj7fdqp89lhi2qmsvrp1wxppb9p77"
}:

pythonPackages.buildPythonPackage rec {
    inherit version;
    name = "simwriter-${version}";

	src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/project/proj1/simwriter";
        inherit rev sha256;
    };

    propagatedBuildInputs = with pythonPackages; [ matplotlib numpy scipy neurotools cheetah bluepy ];
}
