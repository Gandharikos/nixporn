{ lib }:
let
  inherit (lib.attrsets) filterAttrs;
  inherit (lib.strings) hasSuffix;
in
{
  scanPaths =
    path:
    builtins.map (file: path + "/${file}") (
      builtins.attrNames (
        filterAttrs (
          name: type:
          (type == "directory" && builtins.pathExists (path + "/${name}/default.nix"))
          || (name != "default.nix" && hasSuffix ".nix" name)
        ) (builtins.readDir path)
      )
    );
}
