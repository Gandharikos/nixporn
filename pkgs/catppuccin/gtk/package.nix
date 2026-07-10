{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  git,
  python3,
  sassc,
  accents ? [ "blue" ],
  size ? "standard",
  tweaks ? [ ],
  variant ? "frappe",
}:
let
  validAccents = [
    "blue"
    "flamingo"
    "green"
    "lavender"
    "maroon"
    "mauve"
    "peach"
    "pink"
    "red"
    "rosewater"
    "sapphire"
    "sky"
    "teal"
    "yellow"
  ];
  validSizes = [
    "standard"
    "compact"
  ];
  validTweaks = [
    "black"
    "rimless"
    "normal"
    "float"
  ];
  validVariants = [
    "latte"
    "frappe"
    "macchiato"
    "mocha"
  ];

  pname = "catppuccin-gtk";
  version = "1.0.3";
in
lib.checkListOfEnum "${pname}: theme accent" validAccents accents lib.checkListOfEnum
  "${pname}: color variant"
  validVariants
  [ variant ]
  lib.checkListOfEnum
  "${pname}: size variant"
  validSizes
  [ size ]
  lib.checkListOfEnum
  "${pname}: tweaks"
  validTweaks
  tweaks

  stdenvNoCC.mkDerivation
  {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "gtk";
      tag = "v${version}";
      fetchSubmodules = true;
      hash = "sha256-q5/VcFsm3vNEw55zq/vcM11eo456SYE5TQA3g2VQjGc=";
    };

    patches = [ ./fix-inconsistent-theme-name.patch ];

    nativeBuildInputs = [
      gtk3
      sassc
      # Upstream build.py applies GTK theme patches via git apply.
      git
      (python3.withPackages (ps: [ ps.catppuccin ]))
    ];

    postPatch = ''
      substituteInPlace sources/build/args.py \
        --replace-fail "        type=bool," ""
    '';

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes

      python3 build.py ${variant} \
        --accent ${toString accents} \
        ${lib.optionalString (size != [ ]) "--size " + size} \
        ${lib.optionalString (tweaks != [ ]) "--tweaks " + toString tweaks} \
        --dest $out/share/themes

      runHook postInstall
    '';

    meta = {
      description = "Soothing pastel theme for GTK";
      homepage = "https://github.com/catppuccin/gtk";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.all;
    };
  }
