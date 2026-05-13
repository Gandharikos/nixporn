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
      nixfmt
      python3
    ]
    ++ lib.optionals (!minimal) [
      actionlint
      deadnix
      keep-sorted
      nil
      nixd
      shellcheck
      statix
    ];

  shellHook = ''
    echo "Welcome to the nixporn repository."
  '';
}
