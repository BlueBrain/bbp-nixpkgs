{
  sh = ./sh;
  bzip2 = ./bzip2;
  mkdir = ./mkdir;
  cpio = ./cpio;
  ln = ./ln;
  curl = ./curl.bz2;

  bootstrapTools = {
    url = "file:///root/bootstrap-tools-fedora.cpio.bz2";
    sha256 = "0snh0m07zq9dvqdlns0ir6cd7csy4npif7dmav81vz3023qnavab";
  };
}
