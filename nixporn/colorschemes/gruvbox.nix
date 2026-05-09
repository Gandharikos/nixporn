{ lib, common }:
let
  inherit (lib.options) mkEnableOption;
  inherit (common) mkVariantOption;
in
{
  enable = mkEnableOption "Gruvbox colorscheme";
  variant = mkVariantOption {
    variants = [
      "dark"
      "light"
    ];
    default = "dark";
    description = "The Gruvbox variant.";
  };
}
