{ lib, common }:
let
  inherit (lib.options) mkEnableOption;
  inherit (common) mkVariantOption;
in
{
  enable = mkEnableOption "Cyberdream colorscheme";
  variant = mkVariantOption {
    variants = [
      "default"
      "light"
    ];
    default = "default";
    description = "The Cyberdream variant.";
  };
}
