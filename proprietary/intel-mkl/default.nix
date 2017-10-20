{ stdenv
, config
}:

let
  has_icc = config ? intel_compiler_path && config.intel_compiler_path != null;
  compiler_path = if (has_icc) then config.intel_compiler_path else "";

  wrapper = stdenv.mkDerivation {
    name = "intel-mkl";
    unpackPhase = ''echo "no sources"'';
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/lib;

      pushd ${compiler_path}/mkl/lib/intel64
      for i in ./* ; do
        ln -s "${compiler_path}/mkl/lib/intel64/$i" "$out/lib/$i";
      done
      popd

      ln -s ${compiler_path}/mkl/include $out/include
    '';

    preferLocalBuild = true;
    passthru = {
      isMKL = true;
      gcc = stdenv.cc;
    };
  };

in
  if (has_icc) then wrapper else null
