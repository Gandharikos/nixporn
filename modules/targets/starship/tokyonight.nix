{
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf mkMerge;
  inherit (config.nixporn.general) pad;
  inherit (config.nixporn) tokyonight colorscheme;
  inherit (colorscheme) palette slug;
  lang = icon: color: {
    symbol = icon;
    format = "[$symbol ](${color})";
  };
  os = icon: fg: "[${icon} ](fg:${fg})";
  cfg = tokyonight;
  targetCfg = config.nixporn.targets."starship";
in
{
  config = mkIf (cfg.enable && targetCfg.enable) {
    programs.starship.settings =
      let
        pad_style = "fg:gray";
        left_pad = "[${pad.left}](${pad_style})";
        right_pad = "[${pad.right} ](${pad_style})";
        inherit (builtins) concatStringsSep;
      in
      mkMerge [
        {
          palette = slug;
          palettes.${slug} = with palette; {
            inherit
              bg
              fg
              red
              green
              yellow
              blue
              magenta
              cyan
              white
              ;
            gray = bg_highlight;
          };
          username = {
            style_user = "bold blue";
            style_root = "bold red";
          };
          hostname = {
            style = "bold blue";
          };
          git_branch = {
            format = concatStringsSep "" [
              left_pad
              "[$symbol $branch ]($style)(:$remote_branch)"
            ];
            style = "bg:gray fg:green";
          };
          git_status = {
            format = concatStringsSep "" [
              "[$all_status$ahead_behind]($style)"
              right_pad
            ];
            style = "bg:gray fg:red";
          };
          directory = {
            format = concatStringsSep "" [
              left_pad
              "[$read_only]($read_only_style)"
              "[$path]($style)"
              right_pad
            ];
            style = "bg:gray fg:fg";
            read_only_style = "bg:gray fg:red";
          };
          nix_shell = {
            style = "fg:bold blue bg:gray";
            format = concatStringsSep "" [
              left_pad
              "[$symbol(\($name\))]($style)"
              right_pad
            ];
          };
          direnv = {
            style = "fg:bold yellow bg:gray";
            format = concatStringsSep "" [
              left_pad
              "[$symbol$loaded/$allowed]($style)"
              right_pad
            ];
          };
          conda = {
            style = "fg:bold blue bg:gray";
            format = concatStringsSep "" [
              right_pad
              "[$symbol$environment ]($style)"
              right_pad
            ];
          };
          container = {
            style = "fg:bold red dimmed bg:gray";
            format = concatStringsSep "" [
              left_pad
              "[$symbol \[$name\]]($style)"
              right_pad
            ];
          };
          cmd_duration = {
            format = "[$duration ](fg:yellow)";
          };
          status = {
            format = "[$symbol]($style)";
            success_style = "bold green";
          };
        }
        {
          add_newline = true;
          format = builtins.concatStringsSep "" [
            "$os"
            "$username"
            "$hostname"
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
          character = {
            success_symbol = "[❯](bold green)";
            error_symbol = "[](bold red)";
            vicmd_symbol = "[](bold green)";
            vimcmd_replace_one_symbol = "[](bold magenta)";
            vimcmd_replace_symbol = "[](bold magenta)";
            vimcmd_visual_symbol = "[](bold yellow)";
          };
          continuation_prompt = "∙  ┆ ";
          line_break = {
            disabled = false;
          };
          username = {
            format = "[$user]($style)";
            show_always = false;
          };
          hostname = {
            ssh_only = true;
            format = "[@$hostname ]($style)";
          };
          status = {
            symbol = "✗";
            success_symbol = " ";
            not_found_symbol = "󰍉 Not Found";
            not_executable_symbol = " Can't Execute E";
            sigint_symbol = "󰂭 ";
            signal_symbol = "󱑽 ";
            map_symbol = true;
            disabled = false;
          };
          cmd_duration = {
            min_time = 1000;
          };
          direnv = {
            disabled = false;
            symbol = " ";
          };
          nix_shell = {
            heuristic = true; # needed to detect `nix shell`
            symbol = "󱄅 "; # the default unicode is causing issue https://github.com/starship/starship/issues/5924
          };
          conda = {
            ignore_base = true;
          };
          container = {
            symbol = "󰏖 ";
          };
          directory = {
            substitutions = {
              "Desktop" = "󰇄 ";
              "Documents" = "󰈙 ";
              "Downloads" = " ";
              "Share" = "󰒗 ";
              "Templates" = " ";
              "Misc" = " ";
              "Music" = " ";
              "Videos" = " ";
              "Pictures" = " ";
              "Projects" = " ";
              "Workspaces" = "󰊠 ";
              "Repos" = "󰳐 ";
              "Screenshots" = "󰹑 ";
              "Wallpapers" = "󰸉 ";
              "Notes" = "󰠮 ";
              "Dev" = " ";
              ".secrets" = " ";
              ".dotfiles" = " ";
            };
            read_only = " ";
            truncate_to_repo = true;
            truncation_length = 4;
            truncation_symbol = "";
            fish_style_pwd_dir_length = 1;
          };
          git_branch = {
            symbol = "";
          };
          git_status = {
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
          os = {
            disabled = false;
            format = "$symbol";
            symbols = {
              Arch = os "" "blue";
              Alpine = os "" "blue";
              Debian = os "" "red";
              EndeavourOS = os "" "magenta";
              Fedora = os "" "blue";
              NixOS = os "" "blue";
              openSUSE = os "" "green";
              SUSE = os "" "green";
              Ubuntu = os "" "magenta";
              Macos = os "" "white";
            };
          };
          python = lang "" "yellow";
          nodejs = lang "󰛦" "blue";
          bun = lang "󰛦" "blue";
          deno = lang "󰛦" "blue";
          lua = lang "󰢱" "blue";
          rust = lang "" "red";
          java = lang "" "red";
          c = lang "" "blue";
          golang = lang "" "blue";
          dart = lang "" "blue";
          elixir = lang "" "magenta";
        }
      ];
  };
}
