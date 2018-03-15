{ stdenv
, fetchFromGitHub
, libibverbs
, which
, gfortran
}:

stdenv.mkDerivation rec {
	name = "GPI2-${version}";
	version = "1.3.0";

	src = fetchFromGitHub {
		owner = "cc-hpc-itwm";
		repo = "GPI-2";
		rev = "v${version}";
		sha256 = "0hv1xn5cn4mxkvj7k7p7lxpkixb8bbiqpafmiipny553wcjpmw00";
	};

	buildInputs = [ libibverbs  which gfortran];

	buildPhase = ''
		echo "skip, everything in installPhase for GPI"
        '';

	installPhase = ''
		./install.sh ${if (libibverbs != null) then ''--with-infiniband=${libibverbs}'' else ''--with-ethernet''} -p $out
	'';

}




