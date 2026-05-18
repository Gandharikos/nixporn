{
  catppuccin-whiskers,
  hyprcursor,
  inkscape,
  just,
  python3,
  source,
  stdenvNoCC,
  xcur2png,
  xcursorgen,
  zip,
  accent ? "mauve",
  flavor ? "mocha",
}:
let
  cursorName = "catppuccin-${flavor}-${accent}-cursors";
in
stdenvNoCC.mkDerivation {
  pname = cursorName;
  version = "unstable";
  src = source;

  nativeBuildInputs = [
    hyprcursor
    inkscape
    just
    catppuccin-whiskers
    (python3.withPackages (pythonPkgs: [ pythonPkgs.pyside6 ]))
    xcur2png
    xcursorgen
    zip
  ];

  postPatch = ''
    patchShebangs scripts build
  '';

  buildPhase = ''
    runHook preBuild
    just clean
    just build ${flavor} ${accent}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r dist/${cursorName} $out/share/icons/
    runHook postInstall
  '';

  passthru = {
    inherit cursorName;
  };
}
