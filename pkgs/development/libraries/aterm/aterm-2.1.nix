{stdenv, fetchurl}: derivation {
  name = "aterm-2.1";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/aterm/aterm-2.1.tar.gz;
    md5 = "b9d541da35b6d287af1cd8460963a7a8";
  };
  stdenv = stdenv;
}
