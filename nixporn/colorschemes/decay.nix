{ lib, common }:
let
  inherit (lib.options) mkEnableOption;
  inherit (common) mkVariantOption;
in
{
  enable = mkEnableOption "Decay colorscheme";
  variant = mkVariantOption {
    variants = [
      "default"
      "dark"
      "decayce"
      "cosmic"
      "light"
    ];
    default = "default";
    description = "The Decay variant.";
  };
}
