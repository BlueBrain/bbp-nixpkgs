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
  version = "2.3.2-rc2";
  hadoopVersion = "hadoop2.7";

  name = "spark-${version}-bbp";
  tarball = "spark-2.3.2-bin-rc2-patched.tgz";
  src = fetchzip {
    url = "https://github.com/matz-e/bbp-spark/releases/download/v${version}/${tarball}";
    sha256 = "0wwh9azz74bagr2cgi406zzwxc64f5f9bx32viai26ww33niwfgl";
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
    EOF
  '';
})
