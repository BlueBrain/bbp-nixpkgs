{
	platformsBase
}:

let
	pcBase = platformsBase.pcBase;
in 
	{
		powerpc64_linux = pcBase // { kernelArch = "ppc64"; };
	}
