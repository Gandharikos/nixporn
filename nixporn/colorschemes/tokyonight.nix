{ lib, common }:
let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum nullOr;
  inherit (common) mkVariantOption;

  variants = [
    "night"
    "storm"
    "day"
    "moon"
  ];
in
{
  enable = mkEnableOption "Tokyo Night colorscheme";
  variant = mkVariantOption {
    inherit variants;
    default = "moon";
    description = "The Tokyo Night variant.";
  };
  style = mkOption {
    type = nullOr (enum variants);
    default = null;
    description = "Deprecated alias for the Tokyo Night variant.";
  };
}
