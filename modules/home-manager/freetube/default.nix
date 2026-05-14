{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
in
{
  imports = lib.nixporn.scanPaths ./.;

  options.nixporn.freetube.secondaryAccent = lib.mkOption {
    type = lib.types.enum [
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
    default = cfg.colorschemes.catppuccin.accent;
    defaultText = "config.nixporn.colorschemes.catppuccin.accent";
    description = "Secondary accent for FreeTube.";
  };
}
