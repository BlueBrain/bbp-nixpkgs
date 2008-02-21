args : with args; with builderDefs {src="";} null;
	let localDefs = builderDefs (rec {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://www.unixuser.org/~euske/vnc2swf/pyvnc2swf-0.9.3.tar.gz;
			sha256 = "1n6pg6b77lv3g184fb8wpfv9i3nc6hyhrzd515jlki1mnmbgalbi";
		};

		buildInputs = [python];
		configureFlags = [];
	}) null; /* null is a terminator for sumArgs */
	in with localDefs;
stdenv.mkDerivation rec {
	name = "vnc2swf-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
		Program to record an animation from VNC session.
";
	};
}
