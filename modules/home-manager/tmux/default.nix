{ lib, ... }:
{
  imports = lib.nixporn.scanPaths ./.;

  options.nixporn.tmux = {
    statusPosition = lib.mkOption {
      type = lib.types.enum [
        "top"
        "bottom"
      ];
      default = "top";
      description = "Position of the tmux status line.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      description = "Additional tmux configuration.";
      default = "";
      example = ''
        set -g status-interval 5
      '';
    };
  };
}
