{ stdenv
, fetchFromGitHub
, cmake
, openssl
, boost 
}:


stdenv.mkDerivation rec {
    name = "cppnetlib-${version}";
    version = "0.11-bbp";

    src = fetchFromGitHub {
        owner = "BlueBrain";
        repo = "cpp-netlib";
        rev = "ed0b1b65d122a184df8f1a0b2fb3d6ec594229dc";
        sha256 = "1rfyf3px827bf4d1y1bhbkih7y1bfhkbyry537nkzvrrskhz58sc";
    };
    

    buildInputs = [ cmake boost openssl ];



}


