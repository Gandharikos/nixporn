{
  runCommandLocal,
  source,
  accent ? "mauve",
  flavor ? "mocha",
}:
runCommandLocal "catppuccin-fcitx5-${flavor}-${accent}" { } ''
  mkdir -p $out/share/fcitx5/themes
  cp -r ${source}/src/* $out/share/fcitx5/themes/
''
