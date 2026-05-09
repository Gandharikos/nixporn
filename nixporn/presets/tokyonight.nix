{
  lib,
  helpers,
  palettes,
}:
let
  inherit (helpers) mkColorscheme;
in
{
  colorscheme =
    cfg:
    mkColorscheme {
      slug = "tokyonight_${cfg.style}";
      displayName = "Tokyo Night ${lib.toSentenceCase cfg.style}";
      author = "folke";
      description = "A clean, dark and light Neovim colorscheme.";
      palette = palettes.tokyonight.${cfg.style};
    };
}
