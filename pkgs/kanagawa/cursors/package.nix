{
  vimix-cursors,
  cursorThemeName ? "Vimix-Kanagawa-cursors",
  baseColor ? "#1F1F28",
  outlineColor ? "#DCD7BA",
  redColor ? "#C34043",
  greenColor ? "#76946A",
  yellowColor ? "#C0A36E",
  blueColor ? "#7E9CD8",
  magentaColor ? "#957FB8",
  cyanColor ? "#6A9589",
  brightRedColor ? "#E82424",
  brightGreenColor ? "#98BB6C",
  brightYellowColor ? "#E6C384",
  brightMagentaColor ? "#938AA9",
  brightCyanColor ? "#7AA89F",
}:
vimix-cursors.overrideAttrs (old: {
  pname = "vimix-kanagawa-cursors";

  postPatch = (old.postPatch or "") + ''
    find src/svg -type f -name '*.svg' -exec sed -i \
      -e 's/#333333/${baseColor}/Ig' \
      -e 's/#ffffff/${outlineColor}/Ig' \
      -e 's/#FF4332/${redColor}/Ig' \
      -e 's/#ff3d00/${redColor}/Ig' \
      -e 's/#ed1515/${redColor}/Ig' \
      -e 's/#ff2a2a/${redColor}/Ig' \
      -e 's/#4caf50/${greenColor}/Ig' \
      -e 's/#3BBD1C/${greenColor}/Ig' \
      -e 's/#38d83c/${greenColor}/Ig' \
      -e 's/#FDCF01/${yellowColor}/Ig' \
      -e 's/#ffc107/${yellowColor}/Ig' \
      -e 's/#FBB114/${yellowColor}/Ig' \
      -e 's/#FF9508/${yellowColor}/Ig' \
      -e 's/#f67400/${yellowColor}/Ig' \
      -e 's/#1976d2/${blueColor}/Ig' \
      -e 's/#B452CB/${magentaColor}/Ig' \
      -e 's/#1191F4/${cyanColor}/Ig' \
      -e 's/#FF645D/${brightRedColor}/Ig' \
      -e 's/#52CF30/${brightGreenColor}/Ig' \
      -e 's/#FFD305/${brightYellowColor}/Ig' \
      -e 's/#CA70E1/${brightMagentaColor}/Ig' \
      -e 's/#14ADF6/${brightCyanColor}/Ig' \
      {} +
  '';

  installPhase = ''
    runHook preInstall

    install -dm755 "$out/share/icons/${cursorThemeName}"
    cp -pr dist/. "$out/share/icons/${cursorThemeName}/"
    substituteInPlace "$out/share/icons/${cursorThemeName}/index.theme" \
      --replace-fail "Name=Vimix Cursors" "Name=${cursorThemeName}"

    runHook postInstall
  '';

  passthru = (old.passthru or { }) // {
    inherit cursorThemeName;
  };

  meta = old.meta // {
    description = "Vimix cursor theme recolored with the Kanagawa palette";
  };
})
