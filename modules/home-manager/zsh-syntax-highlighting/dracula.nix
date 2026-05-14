{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  sources = pkgs.nixporn.dracula;
  target = "zsh-syntax-highlighting";
  enable = cfg.enable && cfg.colorscheme == "dracula" && cfg.${target}.enable;
in
{
  config = lib.mkIf enable {
    programs.zsh.initContent = lib.mkOrder 950 ''
      source '${sources.zsh-syntax-highlighting}/zsh-syntax-highlighting.sh'
    '';
  };
}
