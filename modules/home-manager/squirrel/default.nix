{
  lib,
  ...
}:
{
  imports = lib.nixporn.scanPaths ./.;

  options.nixporn.squirrel = {
    dir = lib.mkOption {
      type = lib.types.str;
      default = "Library/Rime";
      description = "Directory where Squirrel reads Rime configuration files.";
    };

    fontPoint = lib.mkOption {
      type = lib.types.int;
      default = 18;
      description = "Font point size for the Squirrel candidate window.";
    };
  };

}
