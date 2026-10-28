{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) solarized-osaka;
  inherit (solarized-osaka) slug;
  source = pkgs.nixporn.solarized-osaka;
  target = "yazi";
  flavorName = lib.nixporn.yaziFlavorName slug;
  flavorBase = lib.nixporn.mkYaziFlavor pkgs slug "${source}/extras/yazi/${slug}.toml";
  # Patch the pinned upstream format for Yazi 26.9.1 without changing other flavors.
  flavor = pkgs.runCommand "yazi-${flavorName}-compatible-flavor.toml" { } ''
    substitute ${flavorBase} "$out" \
      --replace-fail '[manager]' '[mgr]' \
      --replace-fail '[completion]' '[cmp]' \
      --replace-fail 'separator_open    = ""' 'sep_left = { open = "", close = "" }' \
      --replace-fail 'separator_close   = ""' 'sep_right = { open = "", close = "" }'

    {
      printf '\n[tabs]\n'
      sed -nE '/^\[manager\]$/,/^\[mode\]$/ {
        s/^tab_(active|inactive)([[:space:]]*=.*)$/\1\2/p
      }' ${flavorBase}
      printf '\n[indicator]\n'
      sed -nE '/^\[manager\]$/,/^\[mode\]$/ {
        s/^hovered([[:space:]]*=.*)$/parent\1\ncurrent\1/p
        s/^preview_hovered([[:space:]]*=.*)$/preview\1/p
      }' ${flavorBase}
    } >> "$out"

    sed -i -E \
      -e '/^\[mgr\]$/,/^\[mode\]$/ {
        /^(tab_active|tab_inactive|tab_width|hovered|preview_hovered)[[:space:]]*=/d
      }' \
      -e '/^\[confirm\]$/,/^\[spot\]$/ s/^content([[:space:]]*=)/body\1/' \
      -e '/^\[help\]$/,/^\[filetype\]$/ {
        s/^on([[:space:]]*=)/chord\1/
        s/^run([[:space:]]*=)/action\1/
      }' "$out"
  '';
  enable = cfg.enable && cfg.colorscheme == "solarized-osaka" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.yazi.theme = lib.nixporn.yaziFlavorTheme slug;
    xdg.configFile."yazi/flavors/${flavorName}.yazi/flavor.toml".source = flavor;
  };
}
