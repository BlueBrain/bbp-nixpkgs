{ stdenv
, fetchFromGitHub
, autoreconfHook
, python }:

stdenv.mkDerivation rec {
  name = "singularity-${version}";
  version = "2.4.6";

  src = fetchFromGitHub {
    owner = "singularityware";
    repo = "singularity";
    rev = version;
    sha256 = "0bs1jqm7v7wv1kdxq8kyqn3gl5m76j0wwwgjyjnndrhczlsh5m1d";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ python ];
  patches = [
    ./configure-no-rpath.patch
  ];

  meta = with stdenv.lib; {
    homepage = http://singularity.lbl.gov/;
    description = "Designed around the notion of extreme mobility of compute and reproducible science, Singularity enables users to have full control of their operating system environment";
    license = "BSD license with 2 modifications";
    platforms = platforms.linux;
    maintainers = [ maintainers.jbedo ];
  };
}
