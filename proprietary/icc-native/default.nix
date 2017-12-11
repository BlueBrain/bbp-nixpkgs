{ stdenv
, which
, config
}:

let
  has_icc = config ? intel_compiler_path && config.intel_compiler_path != null;
  compiler_path = if (has_icc) then config.intel_compiler_path else "";
  compiler_version = config.intel_compiler_version;

  gcc_path = "${stdenv.cc}/bin/gcc";
  gxx_path = "${stdenv.cc}/bin/g++";

  wrapper = stdenv.mkDerivation rec {
    name = "intel-compiler-native-${version}";
    version = compiler_version;

    unpackPhase = '' echo "no sources" '';

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/{bin,include,lib,nix-support};

      echo "contruct icc path from ${compiler_path}";

      ls ${compiler_path}/bin/intel64/ > /dev/null

      pushd ${compiler_path}/bin/intel64/
      for i in ./*
      do
        ln -s ${compiler_path}/bin/intel64/$i $out/bin/$i;
      done
      popd

      ln -s $out/bin/icc $out/bin/cc
      ln -s $out/bin/icpc $out/bin/c++

      pushd ${compiler_path}/compiler/lib/intel64/
      for i in ./*
      do
        ln -s ${compiler_path}/compiler/lib/intel64/$i $out/lib/$i;
      done
      popd

      ln -s ${compiler_path}/compiler/include $out/include

      echo "export NIX_CFLAGS_COMPILE=\"-gcc-name=${gcc_path} \''${NIX_CFLAGS_COMPILE}\"" >> $out/nix-support/compiler_setup.sh
      echo "export NIX_CFLAGS_COMPILE=\"-gxx-name=${gcc_path} \''${NIX_CFLAGS_COMPILE}\"" >> $out/nix-support/compiler_setup.sh
      echo "export NIX_CFLAGS_COMPILE=\"-L$out/lib \''${NIX_CFLAGS_COMPILE}\"" >> $out/nix-support/compiler_setup.sh
    '';

    preferLocalBuild = true;

    passthru = {
      isIcc = true;
      iccVersion = version;
      gcc  = stdenv.cc;
    };
  };

in
  if (has_icc) then wrapper else null
