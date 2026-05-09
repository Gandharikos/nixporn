{ lib, common }:
let
  inherit (lib.options) mkEnableOption;
  inherit (common) mkVariantOption;
in
{
  enable = mkEnableOption "Rose Pine colorscheme";
  variant = mkVariantOption {
    variants = [
      "main"
      "moon"
      "dawn"
    ];
    default = "main";
    description = "The Rose Pine variant.";
  };
}
