{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf mkMerge;
  nixporn =
    lib.nixporn or (import ./. {
      inherit lib;
    });
  cfg = config.nixporn;
  selected = nixporn.resolveColorscheme { inherit cfg; };
in
{
  options.nixporn = nixporn.mkNixpornOptions cfg;

  config = mkMerge [
    {
      assertions = nixporn.mkColorschemeAssertions cfg;
    }
    (mkIf (selected != null) {
      nixporn.colorscheme = {
        inherit (selected)
          palette
          slug
          ;
      };
    })
    (nixporn.mkLegacyColorschemeConfig cfg)
  ];
}
