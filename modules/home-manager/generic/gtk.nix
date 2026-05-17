{ targetPath }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "gtk";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  css = ''
    @define-color window_bg_color ${ansi.bg};
    @define-color window_fg_color ${ansi.fg};
    @define-color view_bg_color ${ansi.bg};
    @define-color view_fg_color ${ansi.fg};
    @define-color headerbar_bg_color ${ansi.black};
    @define-color headerbar_fg_color ${ansi.fg};
    @define-color card_bg_color ${ansi.black};
    @define-color card_fg_color ${ansi.fg};
    @define-color popover_bg_color ${ansi.black};
    @define-color popover_fg_color ${ansi.fg};
    @define-color accent_bg_color ${ansi.blue};
    @define-color accent_fg_color ${ansi.bg};
    @define-color destructive_bg_color ${ansi.red};
    @define-color destructive_fg_color ${ansi.bg};
    @define-color success_bg_color ${ansi.green};
    @define-color success_fg_color ${ansi.bg};
    @define-color warning_bg_color ${ansi.yellow};
    @define-color warning_fg_color ${ansi.bg};
    @define-color error_bg_color ${ansi.red};
    @define-color error_fg_color ${ansi.bg};
  '';
in
{
  config = lib.mkIf enable {
    gtk = {
      enable = true;
      theme = {
        package = pkgs.adw-gtk3;
        name = "adw-gtk3";
      };
      gtk3.extraCss = css;
      gtk4.extraCss = css;
    };
    xdg.configFile = {
      "gtk-3.0/gtk.css".text = css;
      "gtk-4.0/gtk.css".text = css;
    };
  };
}
