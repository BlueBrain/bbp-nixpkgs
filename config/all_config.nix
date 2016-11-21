
let 
  all_config_mods = {} // (import ./intel_config.nix) // (import ./shared_config.nix);
  packages_override = (import ./apply_override.nix { config = all_config_mods;} );
in
  all_config_mods // packages_override



