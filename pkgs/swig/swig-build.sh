#! /bin/sh

export NIX_LDFLAGS=-Wl,-s

. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd SWIG-* || exit 1
./configure --prefix=$out --with-python=$python/bin/python || exit 1
/usr/local/bin/gmake || exit 1
/usr/local/bin/gmake install || exit 1
