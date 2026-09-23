{
  config,
  lib,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.kanagawa) slug variant;
  inherit (cfg) palette;
  variantPalette =
    {
      wave = {
        fg1 = palette.oldWhite;
        bg0 = palette.sumiInk0;
        bg1 = palette.sumiInk3;
        bg2 = palette.sumiInk4;
        bg3 = palette.sumiInk6;
        orange = palette.surimiOrange;
        brightRed = palette.samuraiRed;
        brightGreen = palette.springGreen;
        brightYellow = palette.carpYellow;
        brightBlue = palette.springBlue;
        brightPurple = palette.springViolet1;
        brightCyan = palette.waveAqua2;
        gitAdd = palette.autumnGreen;
        gitChange = palette.autumnYellow;
        comment = palette.fujiGray;
        waveBlue = palette.waveBlue2;
      };
      dragon = {
        fg1 = palette.dragonGray;
        bg0 = palette.dragonBlack0;
        bg1 = palette.dragonBlack3;
        bg2 = palette.dragonBlack4;
        bg3 = palette.dragonBlack6;
        orange = palette.dragonOrange;
        brightRed = palette.waveRed;
        brightGreen = palette.dragonGreen;
        brightYellow = palette.carpYellow;
        brightBlue = palette.springBlue;
        brightPurple = palette.springViolet1;
        brightCyan = palette.waveAqua2;
        gitAdd = palette.dragonGreen;
        gitChange = palette.dragonYellow;
        comment = palette.dragonAsh;
        waveBlue = palette.dragonTeal;
      };
      lotus = {
        fg1 = palette.lotusInk2;
        bg0 = palette.lotusWhite3;
        bg1 = palette.lotusWhite2;
        bg2 = palette.lotusWhite1;
        bg3 = palette.lotusViolet3;
        orange = palette.lotusOrange2;
        brightRed = palette.lotusRed2;
        brightGreen = palette.lotusGreen2;
        brightYellow = palette.lotusYellow2;
        brightBlue = palette.lotusTeal2;
        brightPurple = palette.lotusViolet4;
        brightCyan = palette.lotusAqua2;
        gitAdd = palette.lotusGreen;
        gitChange = palette.lotusYellow;
        comment = palette.lotusGray3;
        waveBlue = palette.lotusBlue1;
      };
    }
    .${variant};
  starshipPalette = {
    color_fg0 = palette.ansi.fg;
    color_fg1 = variantPalette.fg1;
    color_bg0 = variantPalette.bg0;
    color_bg1 = variantPalette.bg1;
    color_bg2 = variantPalette.bg2;
    color_bg3 = variantPalette.bg3;
    color_red = palette.ansi.red;
    color_green = palette.ansi.green;
    color_yellow = palette.ansi.yellow;
    color_blue = palette.ansi.blue;
    color_purple = palette.ansi.magenta;
    color_cyan = palette.ansi.cyan;
    color_orange = variantPalette.orange;
    color_bright_red = variantPalette.brightRed;
    color_bright_green = variantPalette.brightGreen;
    color_bright_yellow = variantPalette.brightYellow;
    color_bright_blue = variantPalette.brightBlue;
    color_bright_purple = variantPalette.brightPurple;
    color_bright_cyan = variantPalette.brightCyan;
    color_git_add = variantPalette.gitAdd;
    color_git_change = variantPalette.gitChange;
    color_git_delete = palette.ansi.red;
    color_comment = variantPalette.comment;
    color_wave_blue = variantPalette.waveBlue;
  };
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.starship.enable;
in
{
  config = lib.mkIf enable {
    programs.starship.settings = {
      palette = slug;
      palettes.${slug} = starshipPalette;

      format = lib.concatStrings [
        "[░▒▓](color_wave_blue)"
        "$os"
        "[](bg:color_purple fg:color_wave_blue)"
        "$username"
        "[](bg:color_blue fg:color_purple)"
        "$directory"
        "[](bg:color_wave_blue fg:color_blue)"
        "$cmd_duration"
        "$git_branch"
        "$git_status"
        "$docker_context"
        "$nodejs"
        "$php"
        "$rust"
        "$time"
        "[ ](color_wave_blue)"
        "$line_break"
        "$character"
      ];

      right_format = "";

      line_break.disabled = false;

      character = {
        success_symbol = "[❯](bold color_green) ";
        error_symbol = "[❯](bold color_red) ";
        vimcmd_symbol = "[❮](bold color_purple) ";
        vimcmd_replace_one_symbol = "[❮](bold color_yellow) ";
        vimcmd_replace_symbol = "[❮](bold color_yellow) ";
        vimcmd_visual_symbol = "[❮](bold color_blue) ";
      };

      os = {
        disabled = false;
        format = "[ $symbol ]($style)";
        style = "bg:color_wave_blue fg:color_fg0";
        symbols = {
          Windows = "󰍲";
          Ubuntu = "󰕈";
          SUSE = "";
          Raspbian = "󰐿";
          Mint = "󰣭";
          Macos = "󰀵";
          Manjaro = "";
          Linux = "󰌽";
          NixOS = "";
          Gentoo = "󰣨";
          Fedora = "󰣛";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          EndeavourOS = "";
          CentOS = "";
          Debian = "󰣚";
          Redhat = "󱄛";
          RedHatEnterprise = "󱄛";
          Pop = "";
        };
      };

      username = {
        show_always = true;
        format = "[ $user ]($style)";
        style_user = "bg:color_purple fg:color_fg0";
        style_root = "bg:color_cyan fg:color_fg0 bold";
      };

      directory = {
        format = "[ $path ]($style)[$read_only]($read_only_style)";
        style = "bg:color_blue fg:color_fg0";
        read_only = "󰌾 ";
        read_only_style = "bg:color_blue fg:color_bright_red dimmed";
      };

      time = {
        disabled = false;
        format = "[ $time ]($style)";
        time_format = "%R";
        style = "bg:color_wave_blue fg:color_fg0";
      };

      cmd_duration = {
        format = "[  $duration ]($style)";
        style = "bg:color_wave_blue fg:color_fg0";
      };

      git_branch = {
        format = "[ $symbol$branch(:$remote_branch)]($style)";
        style = "bg:color_wave_blue fg:color_yellow";
        symbol = "󰘬 ";
        truncation_length = 12;
      };

      git_status = {
        format = "[ $all_status$ahead_behind ]($style)";
        style = "bg:color_wave_blue fg:color_yellow";
      };

      nodejs = {
        format = "[ $symbol($version) ]($style)";
        style = "bg:color_wave_blue fg:color_green";
        not_capable_style = "bg:color_wave_blue fg:color_red";
      };

      php = {
        format = "[ $symbol ($version) ]($style)";
        style = "bg:color_wave_blue fg:color_purple";
        symbol = "";
      };

      rust = {
        format = "[ $symbol ($version) ]($style)";
        style = "bg:color_wave_blue fg:color_orange";
        symbol = "󱘗";
      };

      docker_context = {
        format = "[ $symbol $context ]($style)";
        style = "bg:color_wave_blue fg:color_cyan";
        symbol = "󰡨";
      };
    };
  };
}
