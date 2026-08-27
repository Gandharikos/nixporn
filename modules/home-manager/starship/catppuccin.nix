{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) concatStringsSep;
  cfg = config.nixporn;
  inherit (cfg.colorschemes) catppuccin;
  sources = pkgs.nixporn.catppuccin;
  enable = cfg.enable && cfg.colorscheme == "catppuccin" && cfg.starship.enable;
  themeFile =
    if builtins.pathExists "${sources.starship}/themes/${catppuccin.flavor}.toml" then
      "${sources.starship}/themes/${catppuccin.flavor}.toml"
    else
      "${sources.starship}/${catppuccin.flavor}.toml";
  moduleBg = "surface0";
  contentFg = "subtext0";
  leftPad = color: " [](fg:${color})";
  textRightPad = "[](fg:${moduleBg})";
  segment =
    iconColor: icon: content:
    concatStringsSep "" [
      (leftPad iconColor)
      "[${icon} ](fg:crust bg:${iconColor})"
      "[ ${content}](fg:${contentFg} bg:${moduleBg})"
      textRightPad
    ];
  lang = symbol: color: {
    inherit symbol;
    format = segment color "$symbol" "( $version)";
  };
  os = icon: "[${icon} ](fg:crust bg:${catppuccin.accent})";
in
{
  config = lib.mkIf enable {
    programs.starship.settings = (lib.importTOML themeFile) // {
      palette = "catppuccin_${catppuccin.flavor}";
      add_newline = true;
      format = concatStringsSep "" [
        "$os"
        "$hostname"
        "$username"
        "$directory"
        "$git_branch"
        "$git_status"
        "$nix_shell"
        "$direnv"
        "$conda"
        "$container"
        "$python"
        "$nodejs"
        "$lua"
        "$rust"
        "$java"
        "$c"
        "$golang"
        "$cmd_duration"
        "$status"
        "$line_break"
        "$character"
      ];

      os = {
        disabled = false;
        format = concatStringsSep "" [
          "[](fg:${catppuccin.accent})"
          "$symbol"
        ];
        symbols = {
          Arch = os "";
          Alpine = os "";
          Debian = os "";
          EndeavourOS = os "";
          Fedora = os "";
          NixOS = os "";
          openSUSE = os "";
          SUSE = os "";
          Ubuntu = os "";
          Macos = os "";
        };
      };

      username = {
        show_always = false;
        style_user = "fg:${contentFg} bg:${moduleBg}";
        style_root = "fg:red bg:${moduleBg}";
        format = segment "blue" "" "$user";
      };

      hostname = {
        ssh_only = false;
        style = "fg:${contentFg} bg:${moduleBg}";
        format = "[ $hostname]($style)${textRightPad}";
      };

      directory = {
        style = "fg:${contentFg} bg:${moduleBg}";
        read_only_style = "fg:red bg:${moduleBg}";
        format = concatStringsSep "" [
          (leftPad "peach")
          "[ ](fg:crust bg:peach)"
          "[$read_only]($read_only_style)"
          "[ $path]($style)"
          textRightPad
        ];
        read_only = " ";
        truncate_to_repo = true;
        truncation_length = 4;
        truncation_symbol = "";
        fish_style_pwd_dir_length = 1;
        substitutions = {
          Desktop = "󰇄 ";
          Developer = "󰲋 ";
          Documents = "󰈙 ";
          Downloads = " ";
          Share = "󰒗 ";
          Templates = " ";
          Misc = " ";
          Music = "󰝚 ";
          Videos = " ";
          Pictures = " ";
          Projects = " ";
          Workspaces = "󰊠 ";
          Repos = "󰳐 ";
          Screenshots = "󰹑 ";
          Wallpapers = "󰸉 ";
          Notes = "󰠮 ";
          Dev = " ";
          ".secrets" = " ";
          ".dotfiles" = " ";
        };
      };

      git_branch = {
        symbol = "";
        style = "fg:${contentFg} bg:${moduleBg}";
        format = concatStringsSep "" [
          (leftPad "green")
          "[$symbol ](fg:crust bg:green)"
          "[ $branch(:$remote_branch)]($style)"
        ];
      };

      git_status = {
        style = "fg:${catppuccin.accent} bg:${moduleBg}";
        format = concatStringsSep "" [
          "[ $all_status$ahead_behind]($style)"
          textRightPad
        ];
        conflicted = " ";
        ahead = " ";
        behind = " ";
        diverged = "󰆗 ";
        up_to_date = " ";
        untracked = " ";
        stashed = " ";
        modified = " ";
        staged = " ";
        renamed = " ";
        deleted = " ";
      };

      nix_shell = {
        heuristic = false;
        symbol = "󱄅";
        format = segment "blue" "$symbol" "(\\($name\\))";
      };

      direnv = {
        disabled = false;
        symbol = "";
        format = segment "yellow" "$symbol" "$loaded/$allowed";
      };

      conda = {
        symbol = "";
        format = segment "blue" "$symbol" "$environment";
        ignore_base = true;
      };

      container = {
        symbol = "󰏖";
        format = segment "red" "$symbol" "\\[$name\\]";
      };

      bun = lang "󰛦" "blue";
      c = lang "" "blue";
      deno = lang "󰛦" "blue";
      dart = lang "" "blue";
      elixir = lang "" "mauve";
      golang = lang "" "blue";
      java = lang "" "red";
      lua = lang "󰢱" "blue";
      nodejs = lang "󰛦" "blue";
      rust = lang "" "red";

      python = (lang "" "yellow") // {
        format = segment "yellow" "$symbol" "( $version)(\\(#$virtualenv\\))";
      };

      line_break.disabled = false;

      character = {
        disabled = false;
        success_symbol = "[❯](bold fg:green)";
        error_symbol = "[](bold fg:red)";
        vimcmd_symbol = "[](bold fg:green)";
        vimcmd_replace_one_symbol = "[](bold fg:mauve)";
        vimcmd_replace_symbol = "[](bold fg:mauve)";
        vimcmd_visual_symbol = "[](bold fg:yellow)";
      };

      cmd_duration = {
        min_time = 1000;
        format = segment "yellow" "" "in $duration";
        disabled = false;
        show_notifications = true;
        min_time_to_notify = 45000;
      };

      status = {
        symbol = "✗";
        success_symbol = "";
        not_found_symbol = "󰍉 Not Found";
        not_executable_symbol = " Can't Execute E";
        sigint_symbol = "󰂭 ";
        signal_symbol = "󱑽 ";
        map_symbol = true;
        disabled = false;
        format = segment "red" "$symbol" "$status";
      };
    };
  };
}
