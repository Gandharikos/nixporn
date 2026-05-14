{ lib }:
let
  inherit (lib)
    attrNames
    filter
    genAttrs
    hasSuffix
    mkDefault
    mkOption
    removeSuffix
    types
    unique
    ;

  sourceFiles = attrNames (builtins.readDir ../../sources);

  colorschemeNames = builtins.sort builtins.lessThan (
    map (file: removeSuffix ".json" file) (filter (hasSuffix ".json") sourceFiles)
  );

  source = name: builtins.fromJSON (builtins.readFile (../../sources + "/${name}.json"));

  variants = name: (source name).variants;

  variantNames = name: builtins.sort builtins.lessThan (attrNames (variants name));

  sourceDefaultVariant =
    name: if (variants name) ? default then "default" else builtins.head (variantNames name);

  colorschemeModule =
    name:
    let
      modulePath = ./. + "/${name}.nix";
    in
    if builtins.pathExists modulePath then
      import modulePath {
        inherit lib name;
        defaultVariant = sourceDefaultVariant name;
        variantNames = variantNames name;
        variants = variants name;
      }
    else
      {
        options.variant = mkOption {
          type = types.enum (variantNames name);
          default = sourceDefaultVariant name;
          description = "The ${name} variant.";
        };
        variantFor = colorscheme: colorscheme.variant;
        slugFor = _: variant: "${name}-${variant}";
      };

  upstreamTargetsFor = name: (colorschemeModule name).targets or (source name).targets or { };

  ansiColorNames = [
    "bg"
    "black"
    "blue"
    "bright_black"
    "bright_blue"
    "bright_cyan"
    "bright_green"
    "bright_magenta"
    "bright_red"
    "bright_white"
    "bright_yellow"
    "cyan"
    "fg"
    "green"
    "magenta"
    "red"
    "white"
    "yellow"
  ];

  first =
    palette: names:
    let
      found = filter (name: palette ? ${name}) names;
    in
    if found == [ ] then null else palette.${builtins.head found};

  pick =
    palette: names:
    let
      value = first palette names;
    in
    if value == null then
      throw "Missing ANSI color from palette keys: ${builtins.toString names}"
    else
      value;

  genericAnsiFor =
    palette:
    let
      bg = pick palette [
        "bg"
        "background"
        "base"
      ];
      fg = pick palette [
        "fg"
        "foreground"
        "text"
      ];
      black = pick palette [
        "black"
        "ansi_black"
        "crust"
      ];
      red = pick palette [
        "red"
        "ansi_red"
        "love"
      ];
      green = pick palette [
        "green"
        "ansi_green"
        "pine"
      ];
      yellow = pick palette [
        "yellow"
        "ansi_yellow"
        "gold"
      ];
      blue = pick palette [
        "blue"
        "ansi_blue"
        "sapphire"
      ];
      magenta = pick palette [
        "magenta"
        "ansi_magenta"
        "mauve"
        "iris"
        "purple"
        "pink"
      ];
      cyan = pick palette [
        "cyan"
        "ansi_cyan"
        "foam"
        "teal"
        "sky"
      ];
      white = pick palette [
        "white"
        "ansi_white"
        "text"
        "fg"
        "base3"
        "base0"
      ];
      bright_white = pick palette [
        "ansi_bright_white"
        "bright_white"
        "brightwhite"
        "base3"
        "base4"
        "text"
        "fg"
      ];
      bright_black = pick palette [
        "ansi_bright_black"
        "bright_black"
        "brightblack"
        "base01"
        "base00"
        "overlay0"
        "comment"
        "grey"
      ];
      bright_red = pick palette [
        "ansi_bright_red"
        "bright_red"
        "brightred"
        "red"
      ];
      bright_green = pick palette [
        "ansi_bright_green"
        "bright_green"
        "brightgreen"
        "green"
      ];
      bright_yellow = pick palette [
        "ansi_bright_yellow"
        "bright_yellow"
        "brightyellow"
        "yellow"
      ];
      bright_blue = pick palette [
        "ansi_bright_blue"
        "bright_blue"
        "brightblue"
        "blue"
      ];
      bright_magenta = pick palette [
        "ansi_bright_magenta"
        "bright_magenta"
        "brightmagenta"
        "magenta"
        "purple"
        "pink"
      ];
      bright_cyan = pick palette [
        "ansi_bright_cyan"
        "bright_cyan"
        "brightcyan"
        "cyan"
      ];
    in
    {
      inherit
        bg
        black
        blue
        bright_black
        bright_blue
        bright_cyan
        bright_green
        bright_magenta
        bright_red
        bright_white
        bright_yellow
        cyan
        fg
        green
        magenta
        red
        white
        yellow
        ;
    };

  paletteFor =
    name: variant:
    let
      inherit ((variants name).${variant}) palette;
      ansiFor = (colorschemeModule name).ansiFor or (_: genericAnsiFor);
    in
    palette
    // {
      ansi = ansiFor variant palette;
    };

  mkDefaultAttrs = lib.mapAttrs (
    _: value: if builtins.isAttrs value then mkDefaultAttrs value else mkDefault value
  );

  commonColorschemeOptions = name: {
    slug = mkOption {
      type = types.str;
      readOnly = true;
      description = "The resolved ${name} slug.";
    };

    palette = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf types.anything;

        options.ansi = mkOption {
          type = types.submodule {
            options = genAttrs ansiColorNames (
              color:
              mkOption {
                type = types.str;
                description = "The ${color} ANSI color.";
              }
            );
          };
          default = { };
          description = "ANSI colors derived from the ${name} palette.";
        };
      };
      description = "The resolved ${name} palette.";
    };

    polarity = mkOption {
      type = types.enum [
        "light"
        "dark"
      ];
      internal = true;
      readOnly = true;
      description = "The resolved ${name} light/dark polarity.";
    };

    targets = mkOption {
      type = types.attrsOf types.anything;
      default = upstreamTargetsFor name;
      description = "Upstream ${name} target metadata.";
    };
  };

  targetsFrom =
    directory:
    if builtins.pathExists directory then
      let
        entries = builtins.readDir directory;
      in
      filter (name: entries.${name} == "directory") (attrNames entries)
    else
      [ ];
in
{
  inherit colorschemeNames;

  targetNames = builtins.sort builtins.lessThan (
    unique ((targetsFrom ../home-manager) ++ (targetsFrom ../nixos))
  );

  inherit paletteFor;

  polarityFor =
    name: variant:
    let
      lightVariants = (colorschemeModule name).lightVariants or [ ];
    in
    if builtins.elem variant lightVariants then "light" else "dark";

  variantFor =
    name: colorscheme:
    ((colorschemeModule name).variantFor or (colorscheme: colorscheme.variant)) colorscheme;

  slugFor =
    name: colorscheme: variant:
    ((colorschemeModule name).slugFor or (_: variant: "${name}-${variant}")) colorscheme variant;

  mkColorschemeOptions =
    name: commonColorschemeOptions name // ((colorschemeModule name).options or { });

  mkColorschemeConfig =
    name: colorscheme:
    let
      variant = ((colorschemeModule name).variantFor or (colorscheme: colorscheme.variant)) colorscheme;
    in
    {
      slug = ((colorschemeModule name).slugFor or (_: variant: "${name}-${variant}")) colorscheme variant;
      palette = mkDefaultAttrs (paletteFor name variant);
      polarity =
        let
          lightVariants = (colorschemeModule name).lightVariants or [ ];
        in
        if builtins.elem variant lightVariants then "light" else "dark";
    };
}
