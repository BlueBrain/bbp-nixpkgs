{ stdenv
, patchelf }:



stdenv.mkDerivation rec {
    name = "patchelf-rewire-wrapper";


    buildCommand = ''
        mkdir -p  $out/bin


        cat > $out/bin/patchelf_rewire << EOF
        #!${stdenv.shell}

        if [[ "\$1" == "" ]]; then
            echo "Error require at least one argument"
            echo "\t Usage \$0 [binary_to_rewire]"
            exit 1
        fi

        export BINARY_FILE="\$1"
        echo "Rewire interpreter and RPATH for \$BINARY_FILE"

        patchelf --set-interpreter  $(cat $NIX_CC/nix-support/dynamic-linker) \$BINARY_FILE

        patchelf --set-rpath "${stdenv.cc.libc}/lib:\$NIX_PATCHELF_LIB_RPATH" \$BINARY_FILE

        EOF


        chmod a+x $out/bin/patchelf_rewire
    '';

    propagatedBuildInputs = [ patchelf ];

}
