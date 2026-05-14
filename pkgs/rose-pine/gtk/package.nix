{
  stdenvNoCC,
  source,
}:

stdenvNoCC.mkDerivation {
  pname = "rose-pine-gtk";
  version = "unstable";

  src = source;

  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes $out/share/icons
    cp -r gtk3/* $out/share/themes/
    cp -r icons/* $out/share/icons/

    runHook postInstall
  '';
}
