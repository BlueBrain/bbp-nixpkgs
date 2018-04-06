"""What is my use-case

Usage:
  whatismyuc [-r | --rack] [-n] [-a | --all]
  whatismyuc [-r | --rack] [-n] <node>...
  whatismyuc -h | --help
  whatismyuc --version

Options:
  -h --help  Show this screen.
  -r --rack  Show node rack instead of use-case.
  -a --all   Show use-case of all allocated nodes.
  -n         Show numerical value.
  --version  Show version.

If node name is not given, content of SLURMD_NODENAME
environment variable is used (SLURM_NODELIST if --all option
is passed), otherwise machine's hostname.
"""
import os
import re
import socket
import sys
import unittest

from ClusterShell.NodeSet import NodeSet
import docopt


ENV_NODE_VAR_RE = re.compile(r"UC(\d+)_NODES")
ENV_RACK_VAR_RE = re.compile(r"RACK(\d+)_NODES")
BB5_CLUSTER = dict(
  UC1_NODES="r1i0n[0-35],r1i1n[0-35],r1i2n[0-35],r1i3n[0-2],r1i3n[9-11],r1i3n[18-20],r1i3n[27-29]",
  UC2_NODES="r2i3n[0-6]",
  UC3_NODES="r1i4n[0-35],r1i5n[0-35],r1i6n[0-35],r1i7n[2-4],r1i7n[11-13],r1i7n[20-22],r1i7n[29-31]",
  UC4_NODES="r1i7n[0-1],r1i7n[9-10],r1i7n[18-19],r1i7n[27-28],r2i0n[0-35],r2i1n[0-35]",
  UC5_NODES="r1i0n[0-35],r1i1n[0-35],r1i2n[0-35],r1i3n[0-2],r1i3n[9-11],r1i3n[18-20],r1i3n[27-29],r1i4n[0-35],r1i5n[0-35],r1i6n[0-35],r1i7n[2-4],r1i7n[11-13],r1i7n[20-22],r1i7n[29-31],r1i7n[0-1],r1i7n[9-10],r1i7n[18-19],r1i7n[27-28],r2i3n[0-6],r2i0n[0-35],r2i1n[0-35]",
  RACK1_NODES="r1i0n[0-35],r1i1n[0-35],r1i2n[0-35],r1i3n[0-2],r1i3n[9-11],r1i3n[18-20],r1i3n[27-29],r1i4n[0-35],r1i5n[0-35],r1i6n[0-35],r1i7n[2-4],r1i7n[11-13],r1i7n[20-22],r1i7n[29-31],r1i7n[0-1],r1i7n[9-10],r1i7n[18-19],r1i7n[27-28]",
  RACK2_NODES="r2i3n[0-6],r2i0n[0-35],r2i1n[0-35]",
  UC4_NODES_R1="r1i7n[0-1],r1i7n[9-10],r1i7n[18-19],r1i7n[27-28]",
  UC4_NODES_R2="r2i0n[0-35],r2i1n[0-35]",
)
FILTERED_UC = {"5"}


class UCResolver(object):
  def __init__(self):
    self.use_cases = UCResolver._defs_from_env(ENV_NODE_VAR_RE)
    self.racks = UCResolver._defs_from_env(ENV_RACK_VAR_RE)
    for uc in self.use_cases:
      for rack in self.racks:
        var = "UC{UC}_NODES_R{RACK}".format(UC=uc, RACK=rack)
        value = os.environ.get(var)
        if value is not None:
          self.racks[rack] += "," + value
    self.use_cases = dict((k, NodeSet(v)) for k, v in self.use_cases.items())
    self.racks = dict((k, NodeSet(v)) for k, v in self.racks.items())


  def uc(self, node):
    for value in self._look_for_def(self.use_cases, node):
      if value not in FILTERED_UC:
        yield value

  def rack(self, node):
    return self._look_for_def(self.racks, node)

  @staticmethod
  def _look_for_def(dfns, node):
    for name, nodeset in dfns.items():
      if node in nodeset:
        yield name

  def _defs_from_env(regex):
    eax = {}
    for key, value in os.environ.items():
      match = regex.match(key)
      if match:
        uc = match.groups()[0]
        eax[uc] = value
    return eax


def main():
  os.environ.update(BB5_CLUSTER)
  arguments = docopt.docopt(__doc__, version="1.0")
  nodes = arguments['<node>']
  if not nodes:
    if arguments['--all']:
      nodes_str = os.environ.get('SLURM_NODELIST')
      if nodes_str:
        nodes = NodeSet(nodes_str)
    else:
      nodes = [
        os.environ.get('SLURMD_NODENAME',
                       socket.gethostname())
      ]

  if len(nodes) > 1:
    print_format = "{node}:{data}"
  else:
    print_format = "{data}"
  resolver = UCResolver()
  if arguments['--rack']:
    str_prefix = "rack"
    method = resolver.rack
  else:
    str_prefix = "uc"
    method = resolver.uc
  for node in nodes:
    for result in method(node):
      if arguments['-n']:
        print(print_format.format(node=node, data=result))
      else:
        print(print_format.format(node=node, data=str_prefix + result))
    else:
      print('Error: {node}: unknown {prefix}'.format(node=node,
                                                     prefix=str_prefix),
            file=sys.stderr)

if __name__ == '__main__':
  main()
