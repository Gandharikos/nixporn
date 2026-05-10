{ lib }:
let
  removeHashtag =
    color:
    let
      len = builtins.stringLength color;
      prefix = builtins.substring 0 1 color;
    in
    if prefix == "#" then builtins.substring 1 (len - 1) color else color;

  hexDigits = "0123456789abcdef";

  toHex2 =
    n:
    let
      high = builtins.div n 16;
      low = lib.trivial.mod n 16;
    in
    builtins.substring high 1 hexDigits + builtins.substring low 1 hexDigits;

  rgba =
    hex: alpha:
    let
      h = removeHashtag hex;
      a =
        if lib.isString alpha then
          removeHashtag alpha
        else if lib.isFloat alpha then
          toHex2 (builtins.floor (alpha * 255))
        else
          builtins.toString alpha;
    in
    "rgba(${h}${a})";

  gradient =
    h1: a1: h2: a2: angle:
    lib.strings.concatStringsSep " " [
      (rgba h1 a1)
      (rgba h2 a2)
      "${toString angle}deg"
    ];
in
{
  inherit
    gradient
    removeHashtag
    rgba
    ;
}
