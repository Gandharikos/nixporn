{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "sway";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      wayland.windowManager.sway.extraConfigEarly = ''
        set $nixporn_bg ${ansi.bg}
        set $nixporn_fg ${ansi.fg}
        set $nixporn_inactive ${ansi.black}
        set $nixporn_accent ${ansi.blue}
        set $nixporn_urgent ${ansi.red}

        client.focused          $nixporn_accent $nixporn_accent $nixporn_bg $nixporn_accent $nixporn_accent
        client.focused_inactive $nixporn_inactive $nixporn_inactive $nixporn_fg $nixporn_inactive $nixporn_inactive
        client.unfocused        $nixporn_inactive $nixporn_inactive $nixporn_fg $nixporn_inactive $nixporn_inactive
        client.urgent           $nixporn_urgent $nixporn_urgent $nixporn_bg $nixporn_urgent $nixporn_urgent
      '';
    }
  );
}
