{ colorschemeName }:
{
  config,
  lib,
  pkgs,
  ...
}@moduleArgs:
let
  common = import ../common.nix { inherit colorschemeName; } moduleArgs;
  inherit (common)
    cfg
    colors
    hexToRgb
    hexToRgba
    isDarwin
    isLight
    isLinux
    materialColors
    mkDefault
    mkIf
    slug
    spicetifyColors
    strip
    targetEnabled
    terminalPalette
    tmColorscheme
    ;
in
{
  config = mkIf (targetEnabled "eza") {
    home.sessionVariables.EZA_CONFIG_DIR = mkDefault "${config.xdg.configHome}/eza";
    xdg.configFile."eza/theme.yml".text = with colors; ''
      filekinds:
        normal: {foreground: "${fg}"}
        directory: {foreground: "${blue}", is_bold: true}
        symlink: {foreground: "${cyan}"}
        pipe: {foreground: "${yellow}"}
        block_device: {foreground: "${yellow}"}
        char_device: {foreground: "${yellow}"}
        socket: {foreground: "${magenta}"}
        special: {foreground: "${orange}"}
        executable: {foreground: "${green}", is_bold: true}
      perms:
        user_read: {foreground: "${green}"}
        user_write: {foreground: "${yellow}"}
        user_execute_file: {foreground: "${red}"}
        group_read: {foreground: "${green}"}
        group_write: {foreground: "${yellow}"}
        group_execute: {foreground: "${red}"}
        other_read: {foreground: "${green}"}
        other_write: {foreground: "${yellow}"}
        other_execute: {foreground: "${red}"}
    '';
  };
}
