{
  lib,
  variantNames,
  ...
}:
let
  inherit (lib) mkOption types;

  accents = [
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

  accentSupportTargets = [
    "atuin"
    "broot"
    "cursors"
    "eza"
    "fcitx5"
    "firefox"
    "freetube"
    "fuzzel"
    "gh-dash"
    "gitea"
    "gtk"
    "home-assistant"
    "hyprland"
    "hyprlock"
    "hyprtoolkit"
    "kvantum"
    "lazygit"
    "mako"
    "mpv"
    "qt5ct"
    "television"
    "thunderbird"
    "vesktop"
    "vicinae"
    "vscode"
    "wleave"
    "wlogout"
    "yazi"
  ];
in
{
  lightVariants = [ "latte" ];

  targets =
    lib.mapAttrs (
      port: metadata:
      metadata
      // {
        accentSupport = builtins.elem port accentSupportTargets;
        url = "github:catppuccin/${port}";
      }
    ) (builtins.fromJSON (builtins.readFile ../../pkgs/catppuccin/sources.json))
    // {
      spicetify = {
        url = "github:catppuccin/spicetify";
        rev = "1ec645c4cf7f42f9792b9eeb1bb7930f94593277";
        hash = "sha256-VK9JpXYFuLMkIuMftFkkMy6Y5+ttuxDUYoIiAPlx6YY=";
      };
    };

  options = {
    flavor = mkOption {
      type = types.enum variantNames;
      default = "mocha";
      description = "The Catppuccin flavor to use.";
    };

    accent = mkOption {
      type = types.enum accents;
      default = "mauve";
      description = "The Catppuccin accent color to use.";
    };
  };

  variantFor = colorscheme: colorscheme.flavor;

  slugFor = colorscheme: _: "catppuccin-${colorscheme.flavor}";
}
