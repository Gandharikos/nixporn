{ lib ? null }:
let
  readSource =
    source:
    let
      document = builtins.fromJSON (builtins.readFile source);
    in
    builtins.mapAttrs (_: variant: variant.normalized) document.variants;
in
{
  catppuccin = readSource ../sources/catppuccin.json;
  cyberdream = readSource ../sources/cyberdream.json;
  decay = readSource ../sources/decay.json;
  dracula = (readSource ../sources/dracula.json).default;
  gruvbox = readSource ../sources/gruvbox.json;
  kanagawa = readSource ../sources/kanagawa.json;
  nordic = (readSource ../sources/nordic.json).default;
  "rose-pine" = readSource ../sources/rose-pine.json;
  "solarized-osaka" = readSource ../sources/solarized-osaka.json;
  tokyonight = readSource ../sources/tokyonight.json;
}
