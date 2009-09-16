{stdenv, fetchurl, aclSupport ? false, acl}:

stdenv.mkDerivation rec {
  name = "coreutils-7.6";

  src = fetchurl {
    url = "mirror://gnu/coreutils/${name}.tar.gz";
    sha256 = "1m153jmnrg9v4x6qiw7azd3cjms13s32yihbzb7zi9bw8a5zx6qx";
  };

  buildInputs = stdenv.lib.optional aclSupport acl;

  meta = {
    homepage = http://www.gnu.org/software/coreutils/;
    description = "The basic file, shell and text manipulation utilities of the GNU operating system";

    longDescription = ''
      The GNU Core Utilities are the basic file, shell and text
      manipulation utilities of the GNU operating system.  These are
      the core utilities which are expected to exist on every
      operating system.
    '';

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
