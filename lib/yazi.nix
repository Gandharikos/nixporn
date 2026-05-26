{ lib }:
let
  flavorName = builtins.replaceStrings [ "_" ] [ "-" ];
in
{
  yaziFlavorName = flavorName;

  yaziFlavorTheme =
    name:
    let
      flavor = flavorName name;
    in
    {
      flavor = {
        dark = lib.mkDefault flavor;
        light = lib.mkDefault flavor;
      };
    };

  mkYaziFlavor =
    pkgs: name: source:
    pkgs.runCommand "yazi-${flavorName name}-flavor.toml" { } ''
      substitute ${source} $out \
        --replace 'name = "*"' 'url = "*"' \
        --replace 'name = "*/"' 'url = "*/"'
    '';
}
