{ fetchurl, optional, version, langC, langCC, langFortran, langJava, langAda,
  langGo }:

[(fetchurl {
  url = "mirror://gcc/releases/gcc-${version}/gcc-${version}.tar.bz2";
  sha256 = "10k2k71kxgay283ylbbhhs51cl55zn2q38vj5pk4k950qdnirrlj";
})]
