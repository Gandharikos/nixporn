{ lib, ... }:
let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum;
in
{
  enable = mkEnableOption "Catppuccin colorscheme";
  flavor = mkOption {
    type = enum [
      "latte"
      "frappe"
      "macchiato"
      "mocha"
    ];
    default = "mocha";
    description = "The Catppuccin flavor to use.";
  };
  accent = mkOption {
    type = enum [
      "blue"
      "flamingo"
      "green"
      "lavender"
      "maroon"
      "mauve"
      "peach"
      "pink"
      "red"
      "rosewater"
      "sapphire"
      "sky"
      "teal"
      "yellow"
    ];
    default = "mauve";
    description = "The Catppuccin accent color to use.";
  };
}
