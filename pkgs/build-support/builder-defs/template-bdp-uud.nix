a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "${abort "Specify description"}";
    maintainers = [
      a.lib.maintainers.(abort "Specify maintainer")
    ];
    platforms = with a.lib.platforms; 
      (abort "Specify supported platforms");
  };
}
