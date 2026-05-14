{
  lib,
  name,
  variantNames,
  ...
}:
let
  sources = builtins.fromJSON (builtins.readFile ../../pkgs/decay/sources.json);

  targetSources = {
    alacritty = "terms";
    bat = "bat";
    cava = "cava";
    dunst = "dunst";
    firefox = "firefox";
    gtk = "gtk";
    helix = "helix";
    kitty = "terms";
    mako = "mako";
    polybar = "polybar";
    rofi = "rofi";
    vesktop = "discord";
    vscode = "vscode";
    wezterm = "terms";

    konsole = "terms";
    st = "terms";
    tabby = "terms";
    terminator = "terms";
    tilix = "terms";
    tym = "terms";
    xresources = "terms";
  };
in
{
  targets = lib.mapAttrs (
    _target: sourceName:
    sources.${sourceName}
    // {
      source = sourceName;
    }
  ) targetSources;

  options.variant = lib.mkOption {
    type = lib.types.enum variantNames;
    default = "default";
    description = "The ${name} variant.";
  };

  variantFor = colorscheme: colorscheme.variant;

  slugFor = _: variant: "${name}-${variant}";
}
