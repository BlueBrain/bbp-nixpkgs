{ stdenv
, fetchFromGitHub
, cmake
, openssl
, boost 
}:


stdenv.mkDerivation rec {
    name = "cppnetlib-${version}";
    version = "0.13-release";

    src = fetchFromGitHub {
        owner = "cpp-netlib";
        repo = "cpp-netlib";
        rev = "cef6472065a3d964b765681f5988e28866c26d74";
        sha256 = "1rfyf3px827bf4d1y1bhbkih7y1bfhkbyry537nkzvrrskhz58sa";
    };
    

    buildInputs = [ cmake boost openssl ];



}


