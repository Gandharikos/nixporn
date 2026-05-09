{ lib, common }:
let
  inherit (lib.options) mkEnableOption;
  inherit (common) mkVariantOption;
in
{
  enable = mkEnableOption "Solarized Osaka colorscheme";
  variant = mkVariantOption {
    variants = [
      "dark"
      "light"
    ];
    default = "dark";
    description = "The Solarized Osaka variant.";
  };
}
