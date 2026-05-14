{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  inherit (catppuccin) flavor;
  sources = pkgs.nixporn.catppuccin;
  target = "zsh-syntax-highlighting";
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.zsh.initContent = lib.mkOrder 950 ''
      source '${sources.zsh-syntax-highlighting}/catppuccin_${flavor}-zsh-syntax-highlighting.zsh'
    '';
  };
}
