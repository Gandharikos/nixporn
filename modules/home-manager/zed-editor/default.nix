{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  target = "zed-editor";
in
{
  imports = lib.nixporn.scanPaths ./.;

  options.nixporn.zed-editor = {
    italics = lib.mkEnableOption "the italicized version of theme" // {
      default = true;
    };

    icons = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.${target}.enable;
        defaultText = "config.nixporn.zed-editor.enable";
        description = "Whether to enable Catppuccin icons for Zed.";
      };

      flavor = lib.mkOption {
        type = lib.types.enum [
          "latte"
          "frappe"
          "macchiato"
          "mocha"
        ];
        default = cfg.colorschemes.catppuccin.flavor;
        defaultText = "config.nixporn.colorschemes.catppuccin.flavor";
        description = "Catppuccin flavor for Zed icons.";
      };
    };
  };
}
