{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.solarized-osaka) slug;
  inherit (cfg) palette;
  enable = cfg.enable && cfg.colorscheme == "solarized-osaka" && cfg.starship.enable;
  contextStyle = "fg:blue bg:statusline";
in
{
  config = lib.mkIf enable {
    programs.starship.settings = {
      palette = slug;
      # Match the session, active window, and status backgrounds in the tmux theme.
      palettes.${slug} = {
        inherit (palette)
          blue
          cyan
          green
          red
          yellow
          ;
        text_on_accent = palette.base04;
        surface = palette.base02;
        statusline = palette.bg_statusline;
      };

      format = lib.concatStrings [
        "$os"
        "$username"
        "$hostname"
        "[](fg:blue bg:surface)"
        "$directory"
        "[](fg:surface bg:statusline)"
        "$git_branch"
        "$git_status"
        "$git_state"
        "$nodejs"
        "$python"
        "$rust"
        "$golang"
        "$nix_shell"
        "$docker_context"
        "$cmd_duration"
        "[](fg:statusline bg:surface)"
        "$time"
        "[](fg:surface)"
        "$line_break"
        "$character"
      ];
      right_format = "";
      line_break.disabled = false;

      os = {
        disabled = false;
        format = "[ $symbol]($style)";
        style = "bold fg:text_on_accent bg:blue";
        symbols.NixOS = " ";
      };
      username = {
        show_always = true;
        format = "[ $user ]($style)";
        style_user = "bold fg:text_on_accent bg:blue";
        style_root = "bold fg:text_on_accent bg:blue";
      };
      hostname = {
        format = "[ $hostname ]($style)";
        style = "bold fg:text_on_accent bg:blue";
      };
      directory = {
        format = "[ $path ]($style)[$read_only]($read_only_style)";
        style = "bold fg:blue bg:surface";
        read_only = "󰌾 ";
        read_only_style = "fg:red bg:surface";
      };
      git_branch = {
        format = "[ $symbol$branch(:$remote_branch) ]($style)";
        style = contextStyle;
        symbol = "󰘬 ";
        truncation_length = 24;
      };
      git_status = {
        format = "([ $all_status$ahead_behind ]($style))";
        style = "fg:yellow bg:statusline";
      };
      git_state = {
        format = "[ $state( $progress_current/$progress_total) ]($style)";
        style = "fg:yellow bg:statusline";
      };
      nodejs = {
        format = "[ $symbol($version) ]($style)";
        style = contextStyle;
        not_capable_style = "fg:red bg:statusline";
      };
      python = {
        format = "[ $symbol$version( \\($virtualenv\\)) ]($style)";
        style = contextStyle;
      };
      rust = {
        format = "[ $symbol($version) ]($style)";
        style = contextStyle;
      };
      golang = {
        format = "[ $symbol($version) ]($style)";
        style = contextStyle;
      };
      nix_shell = {
        format = "[ $symbol$state( \\($name\\)) ]($style)";
        style = contextStyle;
        symbol = "󱄅 ";
      };
      docker_context = {
        format = "[ $symbol$context ]($style)";
        style = contextStyle;
      };
      cmd_duration = {
        format = "[  $duration ]($style)";
        style = contextStyle;
      };
      time = {
        disabled = false;
        format = "[ $time ]($style)";
        time_format = "%H:%M";
        style = "fg:blue bg:surface";
      };
      character = {
        format = "$symbol ";
        success_symbol = "[❯](bold blue)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
        vimcmd_replace_one_symbol = "[❮](bold yellow)";
        vimcmd_replace_symbol = "[❮](bold yellow)";
        vimcmd_visual_symbol = "[❮](bold cyan)";
      };
    };
  };
}
