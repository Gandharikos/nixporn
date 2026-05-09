{ inputs }:
{
  imports = [
    ../colorscheme
    ./catppuccin
    ./cyberdream
    ./decay
    ./dracula
    ./gruvbox
    ./kanagawa
    ./nordic
    ./rose-pine
    ./solarized-osaka
    ./tokyonight
  ];

  config._module.args = {
    nixpornSources = {
      inherit (inputs)
        cyberdream
        decay
        dracula
        gruvbox
        kanagawa
        nordic
        rose-pine
        solarized-osaka
        tokyonight
        tokyonight-spotify
        ;
    };
  };
}
