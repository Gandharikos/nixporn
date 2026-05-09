{ lib, ... }:
let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum;
in
{
  enable = mkEnableOption "Tokyo Night colorscheme";
  style = mkOption {
    type = enum [
      "night"
      "storm"
      "day"
      "moon"
    ];
    default = "moon";
    description = "The Tokyo Night style.";
  };
}
