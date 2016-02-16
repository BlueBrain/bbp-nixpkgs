{ stdenv
, fetchgitPrivate
}:

#
# corebluron is the set of mod-files currently used by coreneuron
# and extracted from neurodamus
#
fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/neurodamus/bbp";
    rev = "be841636d2d80355be1e50a7c1c84b71a4b5784d";
    sha256 = "1dg165p799s4x03a1y3sidcjysm9r6ndcgr9j2pbcqfghys6blf2";
    leaveDotGit = true;
}
  



