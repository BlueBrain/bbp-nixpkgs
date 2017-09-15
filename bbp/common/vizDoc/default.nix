# vizDoc creates a tree providing the HTML documentation of a set
# of packages, following the layout expected by the viz-team documentation web
# application. See https://bbpteam.epfl.ch/project/spaces/x/_YufAQ
#
{
  name,

  # The paths whose HTML documentation has to be deployed.
  # Each of them must have a 'doc' output providing an 'html'
  # directory somewhere
  paths,

  pkgs
}:

pkgs.runCommand name
  {
    name = name;
    pkgs = builtins.toJSON (map (drv: {
      name = drv.name;
      version = drv.version;
      doc_path = drv.doc;
      meta = drv.meta;
    }) paths);
  }
  ''
    ${pkgs.python2}/bin/python ${./builder.py}
  ''
