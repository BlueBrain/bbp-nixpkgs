{ config
, fetchgitPrivate
, pkgconfig
, stdenv
, boost
, cmake
, vmmlib
, brayns-latest
}:

stdenv.mkDerivation rec {
    name = "brain-atlas-${version}";
    version = "0.1.0-201806";

    buildInputs = [ stdenv pkgconfig cmake boost vmmlib brayns-latest ];

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/viz/Brayns-UC-BrainAtlas";
        rev = "9e1f78807f0fd3229aa4404d0ddb12dc77680c86";
        sha256 = "0i9dv85kcvx02fsj9hjw78z1zn8y4qb79n3z0ava0rxif7sv45j4";
    };

    enableParallelBuilding = true;
}
