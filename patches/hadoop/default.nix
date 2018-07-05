{ fetchurl
, hadoop
, stdenv
}:

hadoop.overrideAttrs (oldAttr: rec {
  name = "hadoop-2.7.6";
  src = fetchurl {
    url = "mirror://apache/hadoop/common/${name}/${name}.tar.gz";
    sha256 = "0sanwam0k2m40pfsf9l5zxvklv8rvq78xvhd2pbsbiab7ylpwcpj";
  };
})
