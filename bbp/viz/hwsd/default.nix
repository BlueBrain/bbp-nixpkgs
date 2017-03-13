{ stdenv, 
fetchgitExternal, 
boost, 
cmake, 
pkgconfig, 
lunchbox,
opengl,
x11
}:

stdenv.mkDerivation rec {
  name = "hwsd-${version}";
  version = "1.4.0";

  buildInputs = [ stdenv pkgconfig boost cmake lunchbox opengl x11 ];

  src = fetchgitExternal {
    url = "https://github.com/Eyescale/hwsd.git";
    rev = "03b11b572a291f641adb6e5e8fa980121933b387";
    sha256 = "029b70r0py193abp741xk17k7dq1j8br3qs83vwcw7c8dmq0nrwj";
  };


  enableParallelBuilding = true;

  propagatedBuildInputs = [ lunchbox opengl ];
  
}


