{ pkgs }:
{
  catppuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "palette";
    rev = "07d02aa110ef9eb7e7427afca5c73ba9cf7f8ebd";
    hash = "sha256-hsy+GhuM4MSjnwGq1YJSLBFIbVm67SSdPRgObP00mxw=";
  };
  cyberdream = pkgs.fetchFromGitHub {
    owner = "scottmckendry";
    repo = "cyberdream.nvim";
    rev = "d1866f5b606896ca530be00bafbd12a3e6bb6efd";
    hash = "sha256-s31nTDVBAj7kKbcQEQ7BHEibJzk5573OKOMLCClkHZ8=";
  };
  decay = pkgs.fetchFromGitHub {
    owner = "decaycs";
    repo = "decay.nvim";
    rev = "457014541ebcfb29bd660592a0b02f22c9e2d0e2";
    hash = "sha256-ydIef3z69S9Bdl42G7q8amx3RWl+7Z3d4j84H7cxGdU=";
  };
  dracula = pkgs.fetchFromGitHub {
    owner = "Mofiqul";
    repo = "dracula.nvim";
    rev = "ae752c13e95fb7c5f58da4b5123cb804ea7568ee";
    hash = "sha256-h0WQdK74FHJLva3RbyA8WZfX6rAo45wKPb9z4JbYAK8=";
  };
  gruvbox = pkgs.fetchFromGitHub {
    owner = "morhetz";
    repo = "gruvbox";
    rev = "697c00291db857ca0af00ec154e5bd514a79191f";
    hash = "sha256-fmX4WuD25BaaJBZCcUyrtgq1a39tVpxLe3KE72dcQT4=";
  };
  kanagawa = pkgs.fetchFromGitHub {
    owner = "rebelot";
    repo = "kanagawa.nvim";
    rev = "8ad3b4cdcc804b332c32db8f9743667e1bb82b99";
    hash = "sha256-vAq9ZiG3s4x/xFSKt9/o40pptj2y7S8DQqs1dJEdhVU=";
  };
  nordic = pkgs.fetchFromGitHub {
    owner = "andersevenrud";
    repo = "nordic.nvim";
    rev = "c88388b2a5f6e621df2718c316b856d4971bb89d";
    hash = "sha256-ipmt0xD2zTfoh8fyYG4+09uVL2ef98FE9VwWpWJtQks=";
  };
  "rose-pine" = pkgs.fetchFromGitHub {
    owner = "rose-pine";
    repo = "neovim";
    rev = "6a961effd67f6130d36df6d1c05c48c739796dd2";
    hash = "sha256-Jf5jycFdPGugGjGH36owtD+27qptBDjADiam2KxQ/L4=";
  };
  "solarized-osaka" = pkgs.fetchFromGitHub {
    owner = "craftzdog";
    repo = "solarized-osaka.nvim";
    rev = "f675d9a5c58f3b0d6158d665a623f81a62e7bdaf";
    hash = "sha256-haf2hbhE54NAeouBWXFdZPTHSV9IU78BfUL7W4kw0Q8=";
  };
  tokyonight = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim";
    rev = "cdc07ac78467a233fd62c493de29a17e0cf2b2b6";
    hash = "sha256-a9iRWue7DB7s/wNdxqqB51Jya5P9X6sDftqhdmKggU0=";
  };
  tokyonight-spotify = pkgs.fetchFromGitHub {
    owner = "evening-hs";
    repo = "Spotify-Tokyo-Night-Theme";
    rev = "d88ca06eaeeb424d19e0d6f7f8e614e4bce962be";
    hash = "sha256-cLj9v8qtHsdV9FfzV2Qf4pWO8AOBXu51U/lUMvdEXAk=";
  };
}
