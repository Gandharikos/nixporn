{ lib }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum;
in
{
  mkVariantOption =
    {
      variants,
      default,
      description,
    }:
    mkOption {
      type = enum variants;
      inherit default description;
    };
}
