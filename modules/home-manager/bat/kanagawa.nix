{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  inherit (cfg.colorschemes.kanagawa) slug variant;
  colors = import ../generic/kanagawa-colors.nix {
    inherit (cfg) palette;
    inherit variant;
  };
  target = "bat";
  enable = cfg.enable && cfg.colorscheme == "kanagawa" && cfg.${target}.enable;
  xmlSettings =
    settings:
    lib.concatStrings (
      lib.mapAttrsToList (key: value: ''
        <key>${key}</key>
        <string>${value}</string>
      '') settings
    );
  xmlEntry =
    {
      name ? null,
      scope ? null,
      settings,
    }:
    ''
      <dict>
        ${lib.optionalString (name != null) ''
          <key>name</key>
          <string>${name}</string>
        ''}
        ${lib.optionalString (scope != null) ''
          <key>scope</key>
          <string>${scope}</string>
        ''}
        <key>settings</key>
        <dict>${xmlSettings settings}</dict>
      </dict>
    '';
  entries = [
    {
      settings = {
        caret = colors.cursor;
        foreground = colors.fg;
        invisibles = colors.gutter;
        lineHighlight = colors.findHighlight;
        selection = colors.findHighlight;
        inherit (colors) findHighlight;
        selectionBorder = colors.bgSubtle;
        gutterForeground = colors.gutter;
      }
      // lib.optionalAttrs (!cfg.transparent) { background = colors.bg; };
    }
    {
      name = "Comment";
      scope = "comment";
      settings = {
        fontStyle = "italic";
        foreground = colors.comment;
      };
    }
    {
      name = "String";
      scope = "string";
      settings.foreground = colors.string;
    }
    {
      name = "Number";
      scope = "constant.numeric";
      settings.foreground = colors.number;
    }
    {
      name = "Built-in constant";
      scope = "constant.language";
      settings.foreground = colors.constant;
    }
    {
      name = "User-defined constant";
      scope = "constant.character, constant.other";
      settings.foreground = colors.namespace;
    }
    {
      name = "Variable";
      scope = "variable";
      settings.foreground = colors.namespace;
    }
    {
      name = "Ruby's @variable";
      scope = "variable.other.readwrite.instance";
      settings = {
        fontStyle = "";
        foreground = colors.namespace;
      };
    }
    {
      name = "String interpolation";
      scope = "constant.character.escaped, constant.character.escape, string source, string source.ruby";
      settings = {
        fontStyle = "";
        foreground = colors.escape;
      };
    }
    {
      name = "Keyword";
      scope = "keyword";
      settings.foreground = colors.builtin;
    }
    {
      name = "Storage";
      scope = "storage";
      settings = {
        fontStyle = "";
        foreground = colors.keyword;
      };
    }
    {
      name = "Storage type";
      scope = "storage.type";
      settings.foreground = colors.keyword;
    }
    {
      name = "Class name";
      scope = "entity.name.class";
      settings.foreground = colors.type;
    }
    {
      name = "Inherited class";
      scope = "entity.other.inherited-class";
      settings.foreground = colors.type;
    }
    {
      name = "Function name";
      scope = "entity.name.function";
      settings = {
        fontStyle = "";
        foreground = colors.function;
      };
    }
    {
      name = "Function argument";
      scope = "variable.parameter";
      settings.foreground = colors.parameter;
    }
    {
      name = "Tag name";
      scope = "entity.name.tag";
      settings = {
        fontStyle = "";
        foreground = colors.special;
      };
    }
    {
      name = "Tag attribute";
      scope = "entity.other.attribute-name";
      settings = {
        fontStyle = "";
        foreground = colors.namespace;
      };
    }
    {
      name = "Library function";
      scope = "support.function";
      settings = {
        fontStyle = "";
        foreground = colors.special;
      };
    }
    {
      name = "Library constant";
      scope = "support.constant";
      settings = {
        fontStyle = "";
        foreground = colors.special;
      };
    }
    {
      name = "Library class/type";
      scope = "support.type, support.class";
      settings.foreground = colors.type;
    }
    {
      name = "Library variable";
      scope = "support.other.variable";
      settings.foreground = colors.constant;
    }
    {
      name = "Invalid";
      scope = "invalid";
      settings = {
        fontStyle = "";
        foreground = colors.invalid;
      };
    }
    {
      name = "Invalid deprecated";
      scope = "invalid.deprecated";
      settings.foreground = colors.deprecated;
    }
    {
      name = "JSON String";
      scope = "meta.structure.dictionary.json string.quoted.double.json";
      settings.foreground = colors.keyword;
    }
    {
      name = "diff.header";
      scope = "meta.diff, meta.diff.header";
      settings.foreground = colors.function;
    }
    {
      name = "diff.deleted";
      scope = "markup.deleted";
      settings.background = colors.diffDeletedBg;
    }
    {
      name = "diff.inserted";
      scope = "markup.inserted";
      settings.background = colors.diffAddedBg;
    }
    {
      name = "diff.changed";
      scope = "markup.changed";
      settings.background = colors.diffChangedBg;
    }
    {
      scope = "constant.numeric.line-number.find-in-files - match";
      settings.foreground = colors.gutter;
    }
    {
      scope = "entity.name.filename";
      settings.foreground = colors.fgMuted;
    }
    {
      scope = "message.error";
      settings.foreground = colors.error;
    }
    {
      name = "JSON Punctuation";
      scope = "punctuation.definition.string.begin.json - meta.structure.dictionary.value.json, punctuation.definition.string.end.json - meta.structure.dictionary.value.json";
      settings.foreground = colors.punctuation;
    }
    {
      name = "JSON Structure";
      scope = "meta.structure.dictionary.json string.quoted.double.json";
      settings.foreground = colors.keyword;
    }
    {
      name = "JSON String";
      scope = "meta.structure.dictionary.value.json string.quoted.double.json";
      settings.foreground = colors.fg;
    }
    {
      name = "Escape Characters";
      scope = "constant.character.escape";
      settings.foreground = colors.invalid;
    }
    {
      name = "Regular Expressions";
      scope = "string.regexp";
      settings.foreground = colors.namespace;
    }
  ];
  themeFile = "${slug}.tmTheme";
  themeDirectory = pkgs.writeTextDir themeFile ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>name</key>
        <string>${slug}</string>
        <key>settings</key>
        <array>${lib.concatMapStrings xmlEntry entries}</array>
      </dict>
    </plist>
  '';
in
{
  # Ported from https://github.com/rebelot/kanagawa.nvim/pull/306.
  config = lib.mkIf enable {
    programs.bat = {
      config.theme = slug;
      themes.${slug} = {
        src = themeDirectory;
        file = themeFile;
      };
    };
  };
}
