{ stdenv
, pythonPackages
, pkgs
}:


let

    self = pythonPackages;

in
 rec {

    # For a given list of python modules
    # return all there dependencies
    # based on pythonPackages.requiredPythonModules
    #
    getPyModRec = drvs: with pkgs.lib; let
        filterNull = list: filter (x: !isNull x) list;
        conditionalGetRecurse = attr: condition: drv: let f = conditionalGetRecurse attr condition; in
          (if (condition drv) then unique [drv]++(concatMap f (filterNull(getAttr attr drv))) else []);
        _required = drv: conditionalGetRecurse "propagatedBuildInputs" self.hasPythonModule drv;
      in (unique (concatMap _required (filterNull drvs)));


    # function able to gather recursively all the python dependencies of a nix python package
    # it returns the dependencies as a list [ a b c ]
    # used to generate module containing all the necessary python dependencies
    gatherPythonRecDep  = x: let
                                isPythonModule = drv: if (drv.drvAttrs ? pythonPath) then true else false;

                                getPropDepNative = drv: if ( drv.drvAttrs ? propagatedNativeBuildInputs != null)
                                                    then  drv.drvAttrs.propagatedNativeBuildInputs
                                                    else [];
                                getPropDepTarget = drv: if ( drv.drvAttrs ? propagatedBuildInputs != null)
                                                    then  drv.drvAttrs.propagatedBuildInputs
                                                    else [];

                                getPropDep = drv: (getPropDepNative drv) ++ (getPropDepTarget drv);


                                recConcat = deps: if ( deps == [] ) then []
                                                  else [ (builtins.head deps) ] ++ (recConcat (getPropDep (builtins.head deps) ) )
                                                        ++ (recConcat (builtins.tail deps));

                                allRecDep = recConcat ( getPropDep x);

                                allPythonRecDep = builtins.filter isPythonModule allRecDep;

                            in  allPythonRecDep;

  pythonAtLeast = stdenv.lib.versionAtLeast self.python.pythonVersion;

  callPackage = pkgs.newScope self;

  bootstrapped-pip =  callPackage ./bootstrapped-pip { };

    funcsigs1_0_2 = self.buildPythonPackage rec {
        name = "funcsigs-1.0.2";

        src = pkgs.fetchurl {
          url = "mirror://pypi/f/funcsigs/${name}.tar.gz";
          sha256 = "0l4g5818ffyfmfs1a924811azhjj8ax9xd1cffr1mzd3ycn0zfx7";
        };

        buildInputs = with self; [
          unittest2
        ];

        doCheck = false;
    };

    rtree = self.buildPythonPackage (rec {
        name = "rtree-${version}";
        version = "0.8.3";

        src = pkgs.fetchurl {
          url = "mirror://pypi/r/rtree/Rtree-${version}.tar.gz";
          sha256 = "0jc62jbcqqpjcwcly7l9zk25bg72mrxmjykpvfiscgln00qczfbc";
        };

        patchPhase = ''
            sed -i 's@/usr/local@${pkgs.libspatialindex}@g' setup.cfg;
            sed -i "s@find_library(.*@'${pkgs.libspatialindex}/lib/libspatialindex_c.so'@g" rtree/core.py
        '';

        doCheck = false; # UTF-8 tests fails on python2


        buildInputs = with self; [ unittest2 pkgs.libspatialindex numpy ];
        propagatedBuildInputs = with self; [ pkgs.libspatialindex ];

    });

    cached-property = pythonPackages.buildPythonPackage rec {
      name = "cached-property-${version}";
      version = "1.3.1";
      src = pkgs.fetchurl {
        url = "mirror://pypi/c/cached-property/${name}.tar.gz";
        sha256 = "1wwm23dyysdb4444xz1q6b1agpyax101d8fx45s58ms92fzg0qk5";
      };
    };

    certifi17 = pythonPackages.buildPythonPackage rec {
      name = "certifi-${version}";
      version = "2017.11.5";
      src = pkgs.fetchurl {
        url = "mirror://pypi/c/certifi/${name}.tar.gz";
        sha256 = "1h0k6sy3p4csfdayghg2wjbnb1hfz27i5qbr0c7v8dhira8l5isy";
      };
    };

    cookiecutter = pythonPackages.buildPythonPackage rec {
      name = "cookiecutter-${version}";
      version = "1.6.0";
      src = pkgs.fetchurl {
        url = "mirror://pypi/c/cookiecutter/${name}.tar.gz";
        sha256 = "0glsvaz8igi2wy1hsnhm9fkn6560vdvdixzvkq6dn20z3hpaa5hk";
      };

      propagatedBuildInputs = with self; [
        binaryornot
        click
        future
        jinja2-time
        poyo
        requests
        whichcraft
      ];
    };

    hpcbench = pythonPackages.buildPythonPackage rec {
      name = "hpcbench-${version}";
      version = "0.3.6";
      src = pkgs.fetchurl {
       url = "mirror://pypi/h/hpcbench/${name}.tar.gz";
       sha256 = "08a683rmv614y9yqs0g8c7qvczl01p9qnpisw12h0kjpnvldam2n";
      };
      # # For development purpose, and add "pkgs.git" dependency
      # src = pkgs.fetchgit {
      #   url = "https://github.com/tristan0x/hpcbench.git";
      #   rev = "f0978baea4b3863567b7ae07c9a592f0f316a56a";
      #   sha256 = "16l7x69rbn0g1kdl7zk7zaqlgyymib58pm1irwkyr0w4cjifqyvq";
      #   leaveDotGit = true;
      # };
      propagatedBuildInputs = with self; [
        cached-property
        cookiecutter
        docopt
        jinja2
        numpy
        py-elasticsearch
        pyyaml
        setuptools_scm
        six
      ];
    };

    idna_2_6 = pythonPackages.buildPythonPackage rec {
      name = "idna-${version}";
      version = "2.6";
      src = pkgs.fetchurl {
        url = "mirror://pypi/i/idna/${name}.tar.gz";
        sha256 = "13qaab6d0s15gknz8v3zbcfmbj6v86hn9pjxgkdf62ch13imssic";
      };
    };

    jinja2 = pythonPackages.buildPythonPackage rec {
      name = "Jinja2-${version}";
      version = "2.10";
      src = pkgs.fetchurl {
        url = "mirror://pypi/j/jinja2/${name}.tar.gz";
        sha256 = "190l36hfw3wb2n3n68yacjabxyb1pnxwn7vjx96cmjj002xy2jzq";
      };
      propagatedBuildInputs = with self; [ markupsafe ];
    };

    jinja2-time = pythonPackages.buildPythonPackage rec {
      name = "jinja2-time-${version}";
      version = "0.2.0";
      src = pkgs.fetchurl {
        url = "mirror://pypi/j/jinja2-time/${name}.tar.gz";
        sha256 = "0h0dr7cfpjnjj8bgl2vk9063a53649pn37wnlkd8hxjy656slkni";
      };
      propagatedBuildInputs = with self; [
        arrow
        dateutil
        jinja2
      ];
    };

    poyo = pythonPackages.buildPythonPackage rec {
      name = "poyo-${version}";
      version = "0.4.1";
      src = pkgs.fetchurl {
        url = "mirror://pypi/p/poyo/${name}.tar.gz";
        sha256 = "1mjjyc4siq8p44d5ciln0ykf5cldh8zy9aqwzsc50xn7w7ilwfqh";
      };
    };

    progress = pythonPackages.buildPythonPackage rec {
      name = "progress-${version}";
      version = "1.3";
      src = pkgs.fetchurl {
        url = "mirror://pypi/p/progress/${name}.tar.gz";
        sha256 = "02pnlh96ixf53mzxr5lgp451qg6b7ff4sl5mp2h1cryh7gp8k3f8";
      };
    };

    py-elasticsearch = pythonPackages.buildPythonPackage rec {
        name = "elasticsearch-${version}";
        version = "6.0.0";
        src = pkgs.fetchurl {
            url = "mirror://pypi/e/elasticsearch/${name}.tar.gz";
            sha256 = "029q603g95fzkh87xkbxxmjfq5s9xkr9y27nfik6d4prsl0zxmlz";
        };
        propagatedBuildInputs = with self; [ urllib3 ];
        doCheck = false;
    };


    whichcraft = pythonPackages.buildPythonPackage rec {
        name = "whichcraft-${version}";
        version = "0.4.1";
        src = pkgs.fetchurl {
            url = "mirror://pypi/w/whichcraft/${name}.tar.gz";
            sha256 = "1zapij0ggmwp8gmr3yc4fy7pbnh3dag59nvyigrfkdvw734m23cy";
        };
    };

    tqdm =  pythonPackages.buildPythonPackage rec {
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
            sha256 = "10p363s46ddm2afl4mql7yxkrrc2g4mshprzglq8lyqf3yycig7k";
        };

        buildInputs = with pythonPackages; [ nose ];

    };

    nose_testconfig = pythonPackages.buildPythonPackage rec {
        name = "nose_testconfig-${version}";
        version = "0.10";

        src = pkgs.fetchurl {
            url = "https://pypi.python.org/packages/a0/1a/9bb934f1274715083cfe8139d7af6fa78ca5437707781a1dcc39a21697b4/nose-testconfig-0.10.tar.gz";
            sha256 = "1j4l3a77pwq6wgc5gfmhh52jba4sy9vbmy8sldxqg3wfxqh8lcjl";
        };

        buildInputs = with pythonPackages; [ nose ];

    };


    deepdish = pythonPackages.buildPythonPackage rec {
        name = "deepdish-${version}";
        version = "0.3.4";

        src = pkgs.fetchurl {
            url = "mirror://pypi/d/deepdish/${name}.tar.gz";
            sha256 = "198r0h27d8d0ikk79h2xc4jpaw2n602kpjvbm6mzx29l7zyr6f52";
        };

        buildInputs = with self; [ simplegeneric tables scipy pandas six ];

        propagatedBuildInputs = with self; [ scipy tables ];

        doCheck = false;

        passthru = {
        
        };

    };

    elephant = pythonPackages.buildPythonPackage rec {
        name = "elephant-${version}";
        version = "0.4.1";

        src = pkgs.fetchurl {
            url = "mirror://pypi/e/elephant/${name}.tar.gz";
            sha256 = "10dc5v4ff2qsywlwnfnpagayqhjvrn6p6lbgpak0kp5crd21mcl6";
        };

        buildInputs = with self; [ scipy six quantities neo ];

        propagatedBuildInputs = with self; [ scipy  six quantities neo ];

    };
    
    efel = pythonPackages.buildPythonPackage rec {
        name = "efel-${version}";
        version = "2.13.1";

        src = pkgs.fetchurl {
            url = "mirror://pypi/e/efel/${name}.tar.gz";
            sha256 = "0kwkb3j91f9yrx3c5z0s9ip35s005v8ssbzp1spq160ga1ggknig";
        };


        propagatedBuildInputs = with self; [ scipy neo six ];

    };    
   
    peewee = self.buildPythonPackage rec {
     name = "peewee-${version}";
     version = "2.10.2";

     src = pkgs.fetchurl {
         url = "mirror://pypi/p/peewee/peewee-${version}.tar.gz";
         sha256 = "10f2mrd5hw6rjklrzaix2lsxlgc8vx3xak54arcy6yd791zhchi3";
     };

     propagatedBuildInputs = with self; [ cython ];
    };


    neo = pythonPackages.buildPythonPackage rec {
        name = "neo-${version}";
        version = "0.5.1";

        src = pkgs.fetchurl {
            url = "mirror://pypi/n/neo/${name}.tar.gz";
            sha256 = "1yw0xlsyxglgvqqlp18wk197vhnslbr2pwaiv4nljljv7m3fqa32";
        };

        buildInputs = with self; [ scipy quantities ];

        propagatedBuildInputs = with self; [ scipy quantities ];

    };


  cov_core = pythonPackages.buildPythonPackage rec {
    pname = "cov-core";
    version = "1.15.0";
    name = "${pname}-${version}";

    src = pkgs.fetchurl {
        url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
        sha256 = "0k3np9ymh06yv1ib96sb6wfsxjkqhmik8qfsn119vnhga9ywc52a";
      };

    buildInputs = with self; [ coverage ];
  };


  # backport from NixOS 16.09
  backports_shutil_get_terminal_size = pythonPackages.buildPythonPackage rec {
    name = "backports.shutil_get_terminal_size-${version}";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/backports.shutil_get_terminal_size/${name}.tar.gz";
      sha256 = "713e7a8228ae80341c70586d1cc0a8caa5207346927e23d09dcbcaf18eadec80";
    };

  };

  tensorflow-tensorboard = with self; callPackage ./tensorflow-tensorboard {
  };

  # backport from NixOS 16.09

  pathlib2 = pythonPackages.buildPythonPackage rec {
    name = "pathlib2-${version}";
    version = "2.1.0";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pathlib2/${name}.tar.gz";
      sha256 = "deb3a960c1d55868dfbcac98432358b92ba89d95029cddd4040db1f27405055c";
    };

    propagatedBuildInputs = with self; [ six_1_11 ];

  };


  # backport from NixOS 16.09
  simplegeneric = pythonPackages.buildPythonPackage rec {
    version = "0.8.1";
    name = "simplegeneric-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/s/simplegeneric/${name}.zip";
      sha256 = "dc972e06094b9af5b855b3df4a646395e43d1c9d0d39ed345b7393560d0b9173";
    };

  };


  # backport from NixOS 16.09
  pickleshare = pythonPackages.buildPythonPackage rec {
    version = "0.5";
    name = "pickleshare-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/p/pickleshare/${name}.tar.gz";
      sha256 = "c0be5745035d437dbf55a96f60b7712345b12423f7d0951bd7d8dc2141ca9286";
    };

    propagatedBuildInputs = with self; [pathpy];
  };

  lazy = pythonPackages.buildPythonPackage rec {
    version = "1.3";
    name = "lazy-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/lazy/${name}.zip";
      sha256 = "0gcfwv411rng9c0kpild11qq5wzyzq690nc76wkppfh6f6zpf2n8";
    };
  };


  lazy_property = pythonPackages.buildPythonPackage rec {
    version = "0.0.1";
    name = "lazy-property-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/l/lazy-property/${name}.tar.gz";
      sha256 = "100iggkgnm90k3zgylsdj3ahk9hmjhb9wmms663lc8xk95lx671s";
    };

    propagatedBuildInputs = with self; [ simplegeneric ];

  };

  keras = pythonPackages.buildPythonPackage rec {
    version = "2.1.1";
    name = "Keras-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/k/keras/${name}.tar.gz";
      sha256 = "08siyp456avryhpj7dhwg39plc4m2yrk04i9ykni35qdqrc29jph";
    };

    propagatedBuildInputs = with self; [
      numpy
      pyyaml
      scipy
      six
    ];
  };

  py4j_0_10_4 = pythonPackages.buildPythonPackage rec {
    version = "0.10.4";
    name = "py4j-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/py4j/${name}.zip";
      sha256 = "1bkaw3fflcnq44bqrc4fcrd402k74ibx5bqzyqwqffdvrgdvyvs0";
    };
  };

  pypandoc = pythonPackages.buildPythonPackage rec {
    version = "1.4";
    name = "pypandoc-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pypandoc/${name}.tar.gz";
      sha256 = "0nqsq43jzjf2f8w2kdfby0jqfc33knq0kng4hx47cxjaz3ayc579";
    };

    propagatedBuildInputs = with self; [
      pkgs.pandoc
      bootstrapped-pip
      wheel
    ];

    doCheck = false;
  };

  pyspark = pythonPackages.buildPythonPackage rec {
    version = "2.2.0";
    name = "pyspark-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/p/pyspark/${name}.post0.tar.gz";
      sha256 = "0g1slgd24wx3hnkvqxjdd9pcqid5x1yc5pl6kn9i5kh8hq8r9jcx";
    };

    propagatedBuildInputs = with self; [
      py4j_0_10_4
      pypandoc
      setuptools
    ];

    doCheck = false;
  };

  scikit-learn = callPackage ./scikit-learn {
    blas = pkgs.openblasCompat;
  };


  pyzmq4 = (pythonPackages.pyzmq.overrideDerivation ( oldAttr: {
        buildInputs =  ( stdenv.lib.remove pkgs.zeromq3 oldAttr.buildInputs ) ++  [ pkgs.zeromq4 pythonPackages.pytest pythonPackages.tornado ];
 
        propagatedBuildInputs =  ( stdenv.lib.remove pkgs.zeromq3 oldAttr.propagatedBuildInputs ) ++ [ pkgs.zeromq4 pythonPackages.pytest pythonPackages.tornado ];
 
  }));

  jsonpath_ng = pythonPackages.buildPythonPackage rec {
    version = "1.4.2";
    name = "jsonpath_ng-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "h2non";
      repo = "jsonpath-ng";
      rev = "78868574750184b7540b6f7e401fa8624dbe2980";
      sha256 = "0kpdlz5z0qx63cgkpr6v9bahmla96svdvgj319qa3ywhzfpim35v";
    };

    buildInputs = with pythonPackages; [];
    propagatedBuildInputs = with pythonPackages; [
      tornado
      ply
      six
      decorator
    ];

    doCheck = false;
  };

  equation = pythonPackages.buildPythonPackage rec {
    version = "1.2.01";
    name = "Equation-${version}";

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/fd/0d/ede829e7c0c457b651de2792cd19a739e4885477f59832da54d2cc7a1982/Equation-${version}.tar.gz";
      sha256 = "075qaabmxywmkmw48zyv8cff6by4z269g1b4kg8qyx3cgp21v8n8";
    };

    buildInputs = with pythonPackages; [ unittest2 ];

    propagatedBuildInputs = with pythonPackages; [ numpy scipy ];
  };

  pynrrd = pythonPackages.buildPythonPackage rec {
    version = "0.2.2";
    name = "pynrrd-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "mhe";
      repo = "pynrrd";
      rev = "d9e89b9c736f6df0c434d62cfdf28c13f5c7fa99";
      sha256 = "1jv53cxzwf85acnzlkwm7h1j1fylrsx8m3gsr5vln3yjl2v2wy5b";
    };

    buildInputs = with pythonPackages; [ unittest2 ];

    propagatedBuildInputs = with pythonPackages; [ numpy ];
  };

  add-site-dir = stdenv.mkDerivation rec {
    name = "register-site-packages";
    site-packages = pythonPackages.python.sitePackages;

    buildCommand = ''
        mkdir -p "$out/${site-packages}"
        cat <<EOF >"$out/${site-packages}/sitecustomize.py"
import site
import os
site.addsitedir(os.path.dirname(os.path.abspath(__file__)))
EOF
    '';
  };
}
