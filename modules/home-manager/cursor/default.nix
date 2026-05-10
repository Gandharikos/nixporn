{ colorschemeName }:
{
  imports = [
    (import ./generic.nix { inherit colorschemeName; })
  ];
}
