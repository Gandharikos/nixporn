{ targetPath }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixporn;
  target = "glamour";
  colorscheme = cfg.colorscheme;
  hasSpecific = builtins.pathExists (targetPath + "/${colorscheme}.nix");
  enable = cfg.enable && cfg.${target}.enable && !hasSpecific;
  inherit (cfg.palette) ansi;
  themeName = "nixporn-${colorscheme}";

  chroma = {
    text.color = ansi.fg;
    error = {
      color = ansi.fg;
      background_color = ansi.red;
    };
    comment.color = ansi.bright_black;
    comment_preproc.color = ansi.blue;
    keyword.color = ansi.magenta;
    keyword_reserved.color = ansi.magenta;
    keyword_namespace.color = ansi.yellow;
    keyword_type.color = ansi.yellow;
    operator.color = ansi.cyan;
    punctuation.color = ansi.bright_black;
    name.color = ansi.blue;
    name_builtin.color = ansi.orange;
    name_tag.color = ansi.magenta;
    name_attribute.color = ansi.yellow;
    name_class.color = ansi.yellow;
    name_constant.color = ansi.yellow;
    name_decorator.color = ansi.magenta;
    name_function.color = ansi.blue;
    literal_number.color = ansi.orange;
    literal_string.color = ansi.green;
    literal_string_escape.color = ansi.magenta;
    generic_deleted.color = ansi.red;
    generic_emph = {
      color = ansi.fg;
      italic = true;
    };
    generic_inserted.color = ansi.green;
    generic_strong = {
      color = ansi.fg;
      bold = true;
    };
    generic_subheading.color = ansi.cyan;
    background.background_color = ansi.black;
  };

  theme = {
    document = {
      block_prefix = "\n";
      block_suffix = "\n";
      color = ansi.fg;
      margin = 2;
    };
    block_quote = {
      indent = 1;
      indent_token = "> ";
      color = ansi.bright_black;
    };
    paragraph = { };
    list.level_indent = 2;
    heading = {
      block_suffix = "\n";
      color = ansi.fg;
      bold = true;
    };
    h1 = {
      prefix = "# ";
      suffix = " ";
      color = ansi.red;
      bold = true;
    };
    h2 = {
      prefix = "## ";
      color = ansi.orange;
      bold = true;
    };
    h3 = {
      prefix = "### ";
      color = ansi.yellow;
    };
    h4 = {
      prefix = "#### ";
      color = ansi.green;
    };
    h5 = {
      prefix = "##### ";
      color = ansi.cyan;
    };
    h6 = {
      prefix = "###### ";
      color = ansi.blue;
    };
    text = { };
    strikethrough.crossed_out = true;
    emph.italic = true;
    strong.bold = true;
    hr = {
      color = ansi.bright_black;
      format = "\n--------\n";
    };
    item.block_prefix = "- ";
    enumeration.block_prefix = ". ";
    task = {
      ticked = "[x] ";
      unticked = "[ ] ";
    };
    link = {
      color = ansi.blue;
      underline = true;
    };
    link_text = {
      color = ansi.cyan;
      bold = true;
    };
    image = {
      color = ansi.blue;
      underline = true;
    };
    image_text = {
      color = ansi.cyan;
      format = "Image: {{.text}} ->";
    };
    code = {
      prefix = " ";
      suffix = " ";
      color = ansi.green;
      background_color = ansi.black;
    };
    code_block = {
      color = ansi.black;
      margin = 2;
      inherit chroma;
    };
    table = {
      center_separator = "+";
      column_separator = "|";
      row_separator = "-";
    };
    definition_list = { };
    definition_term = { };
    definition_description.block_prefix = "\n=> ";
    html_block = { };
    html_span = { };
  };

  themeFile = pkgs.writeText "${themeName}.json" (builtins.toJSON theme);
in
{
  config = lib.mkIf enable (
    lib.mkDefault {
      home.sessionVariables.GLAMOUR_STYLE = themeFile;
    }
  );
}
