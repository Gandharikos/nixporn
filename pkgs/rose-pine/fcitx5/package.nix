{
  stdenvNoCC,
  source,
}:

stdenvNoCC.mkDerivation {
  pname = "rose-pine-fcitx5";
  version = "unstable";

  src = source;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fcitx5/themes
    cp -r rose-pine rose-pine-dawn rose-pine-moon $out/share/fcitx5/themes/

    runHook postInstall
  '';
}
