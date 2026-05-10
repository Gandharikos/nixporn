{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  python3Packages,
  hyprcursor,
  variant ? "modern",
  cursorThemeName ? "Bibata-Themed-Hyprcursor",
  baseColor ? "#000000",
  outlineColor ? "#FFFFFF",
  watchBackgroundColor ? "#000000",
}:
assert
  builtins.elem variant [
    "modern"
    "modern-right"
    "original"
    "original-right"
  ]
  || builtins.trace "Invalid Bibata variant ${variant}" false;
stdenvNoCC.mkDerivation rec {
  pname = "bibata-hyprcursor-themed";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "Bibata_Cursor";
    rev = "v${version}";
    hash = "sha256-kIKidw1vditpuxO1gVuZeUPdWBzkiksO/q2R/+DUdEc=";
  };

  nativeBuildInputs = [
    hyprcursor
    python3
    python3Packages.tomli
    python3Packages.tomli-w
  ];

  phases = [
    "unpackPhase"
    "configurePhase"
    "buildPhase"
    "installPhase"
  ];

  unpackPhase = ''
    runHook preUnpack

    cp "$src/configs/${
      if lib.hasSuffix "right" variant then "right" else "normal"
    }/x.build.toml" config.toml

    mkdir cursors
    for cursor in "$src/svg/${variant}"/*; do
      cp -r "$src/svg/${variant}/$(readlink "$cursor")" cursors
    done

    chmod -R u+w .

    runHook postUnpack
  '';

  configurePhase = ''
    runHook preConfigure

    cat > manifest.hl <<EOF
    name = ${cursorThemeName}
    description = The Bibata Cursor theme packaged for hyprcursor.
    version = ${version}
    cursors_directory = cursors
    EOF

    find cursors -type f -name '*.svg' | xargs sed -i \
      -e "s/#00FF00/${baseColor}/g" \
      -e "s/#0000FF/${outlineColor}/g" \
      -e "s/#FF0000/${watchBackgroundColor}/g"

    python ${./bibata-hyprcursor-configure.py} config.toml cursors

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    hyprcursor-util --create . --output .
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/icons"
    cp -r "theme_${cursorThemeName}" "$out/share/icons/${cursorThemeName}"

    runHook postInstall
  '';

  meta = {
    description = "Bibata Cursor theme packaged for hyprcursor";
    homepage = "https://github.com/ful1e5/Bibata_Cursor";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
