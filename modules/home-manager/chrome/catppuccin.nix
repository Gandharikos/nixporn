{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) flavor;
  target = "chrome";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;

  identifiers = {
    frappe = "olhelnoplefjdmncknfphenjclimckaf";
    latte = "jhjnalhegpceacdhbplhnakmkdliaddd";
    macchiato = "cmpdlhmnmjhihmcfnigoememnffkimlk";
    mocha = "bkkmolkhemgaeaeggcmfbghljjjoofoh";
  };

  # Google Chrome is not supported since it does not support extensions.
  # See nix-community/home-manager#1383 for more information.
  supportedBrowsers = [
    "brave"
    "chromium"
    "vivaldi"
  ];

  generateConfig = browser: {
    programs.${browser}.extensions = [ { id = identifiers.${flavor}; } ];
  };
in
{
  config = lib.mkIf enable (lib.mkMerge (map generateConfig supportedBrowsers));
}
