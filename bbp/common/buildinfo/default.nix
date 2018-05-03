{stdenv, python, writeText, metas ? {}}:

# Provides a `annotate` function returning a command line
# to apply during the installPhase.
# The command will dump build information in installed executable
# Function takes one optional set in parameter with the following optional key:
#
# Usage with default values:
#
# buildinfo.annotate {
#   meta = {};
#   path = "$out/bin";
# };
#
# Every executable in $out/bin will be patched with the content
# of `meta' set plus extra attributes set internaly.
#
# Other examples:
# buildinfo.annotate {}
# buildinfo.annotate {path="$out/sbin"; }
# buildinfo.annotate {meta={version="1.0", abi=4}; path="$out/sbin"}
stdenv.mkDerivation rec {
  name = "buildinfo";
  version = "1.0";

  unpackPhase = "echo 'no sources needed'";

  metas = args: builtins.toJSON (
    { cc = stdenv.cc.name; } //
    (if (args != null && args ? meta) then args.meta else {})
  );
  json-metas = args: writeText "buildinfo.json" (metas args);
  path = args: if (args != null && args ? path) then args.path else "$out/bin";

  passthru = {
    annotate = args: ''${python.interpreter} ${./annotate} ${path args} ${json-metas args}'';
  };
}
