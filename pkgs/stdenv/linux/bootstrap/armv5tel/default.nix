{
  sh = ./sh;
  bzip2 = ./bzip2;
  mkdir = ./mkdir;
  cpio = ./cpio;
  ln = ./ln;
  curl = ./curl.bz2;

  bootstrapTools = {
    url = "file:///root/bootstrap-tools-nostrip.cpio.bz2";
    sha256 = "08vbd2b6lajrsp66zfalxzdy4bjrvx46agjhlv7zry0g8i5z6sm8";
  };
}
