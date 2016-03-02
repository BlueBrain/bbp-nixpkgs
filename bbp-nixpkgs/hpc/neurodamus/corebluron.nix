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
    sha256 = "100xj2dngz1dx804vd2p5ppwdvacxwn8071jklcmv4vcfq754aa1";
}
  



