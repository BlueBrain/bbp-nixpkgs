{ stdenv
, pythonPackages
, pkgs
}:


let 

	self = pythonPackages;

in 
{



	future_0_16 = self.buildPythonPackage rec {
    	version = "v0.16.0";
	    name = "future-${version}";

	    src = pkgs.fetchurl {
    		url = "http://github.com/PythonCharmers/python-future/archive/${version}.tar.gz";
    		sha256 = "0dynw5hibdpykszpsyhyc966s6zshknrrp6hg4ldid9nph5zskch";
		};

	    propagatedBuildInputs = with self; stdenv.lib.optionals isPy26 [ importlib argparse ];
	    doCheck = false;

	};



	tqdm = 	pythonPackages.buildPythonPackage rec {
	    name = "tqdm-${version}";
	    version = "v4.10.0";

	    src = pkgs.fetchFromGitHub {
	        owner = "tqdm";
	        repo = "tqdm";
	        rev = "bbf08db39931fd6cdff5f8ab42e54148f8b4faa4";
	        sha256 = "08vfbc1x64mgsc9z1zxaq8gdnnvx2y29p91s6r9j1bg7g9vv6w33";

	    };

    	buildInputs = [ pythonPackages.coverage pythonPackages.flake8 pythonPackages.nose ];

	};


	nose_xunitmp = pythonPackages.buildPythonPackage rec {
			name = "nose_xunitmp-${version}";
			version = "0.4";

			src = pkgs.fetchurl {
			url = "https://pypi.python.org/packages/86/cc/ab61fd10d25d090e80326e84dcde8d6526c45265b4cee242db3f792da80f/nose_xunitmp-0.4.0.tar.gz";
			md5 = "c2d1854a9843d3171b42b64e66bbe54f";
			};

			buildInputs = with pythonPackages; [ nose ];

	}; 

	nose_testconfig = pythonPackages.buildPythonPackage rec {
			name = "nose_testconfig-${version}";
			version = "0.10";

			src = pkgs.fetchurl {
				url = "https://pypi.python.org/packages/a0/1a/9bb934f1274715083cfe8139d7af6fa78ca5437707781a1dcc39a21697b4/nose-testconfig-0.10.tar.gz";
				md5 = "2ff0a26ca9eab962940fa9b1b8e97995";
			};

			buildInputs = with pythonPackages; [ nose ];

	};           

  cython = pythonPackages.buildPythonPackage rec {
    name = "Cython-${version}";
    version = "0.25.2";

    src = pkgs.fetchurl {
      url = "https://pypi.io/packages/source/C/Cython/${name}.tar.gz";
      sha256 = "01h3lrf6d98j07iakifi81qjszh6faa37ibx7ylva1vsqbwx2hgi";
    };

    setupPyBuildFlags = ["--build-base=$out"];

    buildInputs = with pythonPackages; [ pkgs.pkgconfig ];

   };
    


}


