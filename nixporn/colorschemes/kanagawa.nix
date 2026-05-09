{ lib, common }:
let
  inherit (lib.options) mkEnableOption;
  inherit (common) mkVariantOption;
in
{
  enable = mkEnableOption "Kanagawa colorscheme";
  variant = mkVariantOption {
    variants = [
      "wave"
      "dragon"
      "lotus"
    ];
    default = "wave";
    description = "The Kanagawa variant.";
  };
}
