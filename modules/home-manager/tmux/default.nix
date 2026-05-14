{ lib, ... }:
{
  imports = lib.nixporn.scanPaths ./.;

  options.nixporn.tmux.extraConfig = lib.mkOption {
    type = lib.types.lines;
    description = "Additional configuration for the catppuccin plugin.";
    default = "";
    example = ''
      set -g @catppuccin_status_modules_right "application session user host date_time"
    '';
  };
}
