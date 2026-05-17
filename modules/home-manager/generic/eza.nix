{ targetPath }:
{ config, lib, ... }:
let
  cfg = config.nixporn;
  target = "eza";
  inherit (cfg) colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;

  color = foreground: ''{foreground: "${foreground}"}'';
  bold = foreground: ''{foreground: "${foreground}", is_bold: true}'';
in
{
  config = lib.mkIf enable {
    xdg.configFile."eza/theme.yml".text = ''
      colourful: true

      filekinds:
        normal: ${color ansi.fg}
        directory: ${color ansi.blue}
        symlink: ${color ansi.cyan}
        pipe: ${color ansi.white}
        block_device: ${color ansi.yellow}
        char_device: ${color ansi.yellow}
        socket: ${color ansi.magenta}
        special: ${color ansi.magenta}
        executable: ${color ansi.green}
        mount_point: ${color ansi.cyan}

      perms:
        user_read: ${bold ansi.red}
        user_write: ${bold ansi.yellow}
        user_execute_file: ${bold ansi.green}
        user_execute_other: ${bold ansi.green}
        group_read: ${color ansi.red}
        group_write: ${color ansi.yellow}
        group_execute: ${color ansi.green}
        other_read: ${color ansi.red}
        other_write: ${color ansi.yellow}
        other_execute: ${color ansi.green}
        special_user_file: ${color ansi.magenta}
        special_other: ${color ansi.bright_black}
        attribute: ${color ansi.bright_black}

      size:
        major: ${color ansi.white}
        minor: ${color ansi.cyan}
        number_byte: ${color ansi.fg}
        number_kilo: ${color ansi.white}
        number_mega: ${color ansi.blue}
        number_giga: ${color ansi.magenta}
        number_huge: ${color ansi.magenta}
        unit_byte: ${color ansi.white}
        unit_kilo: ${color ansi.cyan}
        unit_mega: ${color ansi.magenta}
        unit_giga: ${color ansi.magenta}
        unit_huge: ${color ansi.cyan}

      users:
        user_you: ${color ansi.fg}
        user_root: ${color ansi.red}
        user_other: ${color ansi.yellow}
        group_yours: ${color ansi.white}
        group_other: ${color ansi.bright_black}
        group_root: ${color ansi.red}

      links:
        normal: ${color ansi.blue}
        multi_link_file: ${color ansi.blue}

      git:
        new: ${color ansi.green}
        modified: ${color ansi.yellow}
        deleted: ${color ansi.red}
        renamed: ${color ansi.cyan}
        typechange: ${color ansi.magenta}
        ignored: ${color ansi.bright_black}
        conflicted: ${color ansi.yellow}

      git_repo:
        branch_main: ${color ansi.white}
        branch_other: ${color ansi.magenta}
        git_clean: ${color ansi.green}
        git_dirty: ${color ansi.red}

      security_context:
        colon: ${color ansi.bright_black}
        user: ${color ansi.bright_black}
        role: ${color ansi.magenta}
        typ: ${color ansi.black}
        range: ${color ansi.magenta}

      file_type:
        image: ${color ansi.yellow}
        video: ${color ansi.red}
        music: ${color ansi.green}
        lossless: ${color ansi.cyan}
        crypto: ${color ansi.bright_black}
        document: ${color ansi.fg}
        compressed: ${color ansi.magenta}
        temp: ${color ansi.red}
        compiled: ${color ansi.cyan}
        source: ${color ansi.blue}

      punctuation: ${color ansi.bright_black}
      date: ${color ansi.yellow}
      inode: ${color ansi.white}
      blocks: ${color ansi.bright_black}
      header: ${color ansi.fg}
      octal: ${color ansi.cyan}
      flags: ${color ansi.magenta}

      symlink_path: ${color ansi.cyan}
      control_char: ${color ansi.cyan}
      broken_symlink: ${color ansi.red}
      broken_path_overlay: ${color ansi.black}
    '';
  };
}
