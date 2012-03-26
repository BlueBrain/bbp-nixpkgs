# Given a modules tree (with modules in $modulesTree/lib/modules/VERSION),
# produce a module tree in $out/lib/modules/VERSION that contains only
# the modules identified by `rootModules', plus their dependencies.
# Also generate an appropriate modules.dep.

{ stdenv, modulesTree, nukeReferences, rootModules
, kmod, allowMissing ? false }:

stdenv.mkDerivation {
  name = modulesTree.name + "-shrunk";
  builder = ./modules-closure.sh;
  buildInputs = [nukeReferences];
  inherit modulesTree rootModules kmod allowMissing;
  allowedReferences = ["out"];
}
