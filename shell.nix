{
  pkgs ? import <nixpkgs> {
    inherit system;
    config = { };
    overlays = [ ];
  },
  system ? builtins.currentSystem,
  minimal ? false,
}:
pkgs.mkShellNoCC {
  packages =
    with pkgs;
    [
      nixVersions.nix_2_28
      deadnix
      keep-sorted
      nixfmt
      python3
      treefmt
    ]
    ++ lib.optionals (!minimal) [
      actionlint
      nil
      nixd
      shellcheck
      statix
    ];

  shellHook = ''
    echo "Welcome to the nixporn repository."
  '';
}
