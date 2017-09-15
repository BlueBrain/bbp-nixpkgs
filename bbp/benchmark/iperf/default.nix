{
  stdenv,
  fetchFromGitHub,
  openssl
}:

stdenv.mkDerivation rec {
  name = "iperf-${version}";
  version = "3.2";

  meta = with stdenv.lib; {
    description = "A TCP, UDP, and SCTP network bandwidth measurement tool";
    longDescription = ''
      iperf is a tool for active measurements of the maximum achievable
      bandwidth on IP networks. It supports tuning of various parameters
      related to timing, protocols, and buffers. For each test it reports
      the measured throughput / bitrate, loss, and other parameters.
    '';
    homepage = https://github.com/esnet/iperf;
    license = {
      spdxId = "BSD-3-Clause-LBNL";
      fullName = "Lawrence Berkeley National Labs BSD variant license";
      url = "http://spdx.org/licenses/BSD-3-Clause-LBNL";
    };
    platforms = platforms.unix;
  };

  src = fetchFromGitHub {
    owner = "esnet";
    repo = "iperf";
    rev = "88d907f7fb58bfab5d086c5da60c922e1c582c92";
    sha256 = "0ac8dmimdp1ijqjijkzr0bgsnzymmzg4m823v8shqywrimg5wq18";
  };

  buildInputs = [
    openssl
  ];
}
