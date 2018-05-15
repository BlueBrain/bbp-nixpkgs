{ fetchzip
, jre
, pythonPackages
, sparkOrigin
, stdenv
}:

with stdenv.lib;

(sparkOrigin.override {
  RSupport = false;
  mesosSupport = false;
}).overrideAttrs ( oldAttr: rec {
  version = "2.2.1";
  hadoopVersion = "hadoop2.7";

  name = "spark-${version}-bbp";
  src = fetchzip {
    url = "https://github.com/matz-e/bbp-spark/releases/download/${version}/${name}-bin-${hadoopVersion}.tgz";
    sha256 = "1lhp3jcrx7s1c6ph0wkc99vprbhq6qb3cqa88gwdwq6gf34j57yq";
  };

  installPhase = ''
    mkdir -p $out
    mv bin conf data jars sbin $out

    sed -e 's/INFO, console/WARN, console/' < \
       $out/conf/log4j.properties.template > \
       $out/conf/log4j.properties

    cat > $out/conf/spark-env.sh <<- EOF
    export JAVA_HOME="${jre}"
    export SPARK_HOME="$out"
    export PYSPARK_PYTHON="${pythonPackages.python}/bin/${pythonPackages.python.executable}"
    export PYTHONPATH="\$PYTHONPATH:$PYTHONPATH"
    EOF
  '';
})
