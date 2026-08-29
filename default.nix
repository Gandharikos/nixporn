{
  pkgs ? import <nixpkgs> {
    inherit system;
    config = { };
    overlays = [ ];
  },
  lib ? pkgs.lib,
  system ? builtins.currentSystem,
}:
let
  catppuccinSourceMetadata = builtins.fromJSON (builtins.readFile ./pkgs/catppuccin/sources.json);
  cursorSourceMetadata = builtins.fromJSON (builtins.readFile ./pkgs/cursor-sources.json);
  cyberdreamSourceMetadata = (builtins.fromJSON (builtins.readFile ./sources/cyberdream.json)).source;
  decaySourceMetadata = builtins.fromJSON (builtins.readFile ./pkgs/decay/sources.json);
  draculaSourceMetadata = builtins.fromJSON (builtins.readFile ./pkgs/dracula/sources.json);
  everforestSourceMetadata = (builtins.fromJSON (builtins.readFile ./sources/everforest.json)).source;
  everforestTargetMetadata = builtins.fromJSON (builtins.readFile ./pkgs/everforest/sources.json);
  gruvboxSourceMetadata = (builtins.fromJSON (builtins.readFile ./sources/gruvbox.json)).source;
  extraSourceMetadata = builtins.fromJSON (builtins.readFile ./pkgs/extra-sources.json);
  kanagawaSourceMetadata = (builtins.fromJSON (builtins.readFile ./sources/kanagawa.json)).source;
  nordicSourceMetadata = (builtins.fromJSON (builtins.readFile ./sources/nordic.json)).source;
  rosePineSourceMetadata = builtins.fromJSON (builtins.readFile ./pkgs/rose-pine/sources.json);
  solarizedOsakaSourceMetadata =
    (builtins.fromJSON (builtins.readFile ./sources/solarized-osaka.json)).source;
  tokyonightSourceMetadata = (builtins.fromJSON (builtins.readFile ./sources/tokyonight.json)).source;

  fetchGithubSource =
    {
      url,
      rev,
      narHash,
      ...
    }:
    let
      repository = lib.removePrefix "github:" url;
      parts = lib.splitString "/" repository;
    in
    builtins.fetchTree {
      type = "github";
      owner = builtins.elemAt parts 0;
      repo = builtins.elemAt parts 1;
      inherit rev narHash;
    };

  fetchCatppuccinSource =
    port:
    {
      rev,
      hash,
      ...
    }:
    builtins.fetchTree {
      type = "github";
      owner = "catppuccin";
      repo = port;
      inherit rev;
      narHash = hash;
    };

  catppuccinSources = lib.mapAttrs fetchCatppuccinSource catppuccinSourceMetadata;
  cursorSources = lib.mapAttrs (_: fetchGithubSource) cursorSourceMetadata;
  cyberdreamSource = fetchGithubSource cyberdreamSourceMetadata;
  decaySources = lib.mapAttrs (_: fetchGithubSource) decaySourceMetadata;
  draculaSources = lib.mapAttrs (_: fetchGithubSource) draculaSourceMetadata;
  everforestSource = fetchGithubSource everforestSourceMetadata;
  everforestTargets = lib.mapAttrs (_: fetchGithubSource) everforestTargetMetadata;
  gruvboxSource = fetchGithubSource gruvboxSourceMetadata;
  extraSources = lib.mapAttrs (_: fetchGithubSource) extraSourceMetadata;
  gruvboxContribSource = extraSources.gruvbox-contrib;
  kanagawaSource = fetchGithubSource kanagawaSourceMetadata;
  nordicSource = fetchGithubSource nordicSourceMetadata;
  rosePineSources = lib.mapAttrs (_: fetchGithubSource) rosePineSourceMetadata;
  solarizedOsakaSource = fetchGithubSource solarizedOsakaSourceMetadata;
  tokyonightSource = fetchGithubSource tokyonightSourceMetadata;

  catppuccinCursors = pkgs.callPackage ./pkgs/catppuccin/cursors/package.nix {
    source = catppuccinSources.cursors;
  };

  bibataXcursor = pkgs.callPackage ./pkgs/bibata-xcursor.nix { };

  bibataHyprcursor = pkgs.callPackage ./pkgs/bibata-hyprcursor/package.nix { };

  catppuccinFcitx5 = pkgs.callPackage ./pkgs/catppuccin/fcitx5/package.nix {
    source = catppuccinSources.fcitx5;
  };

  catppuccinGtk = pkgs.callPackage ./pkgs/catppuccin/gtk/package.nix { };

  rosePineCursors = pkgs.callPackage ./pkgs/rose-pine/cursors/package.nix {
    source = rosePineSources.cursors;
  };

  googleCursor = pkgs.callPackage ./pkgs/google-cursor/package.nix {
    source = cursorSources.google-cursor;
  };

  xcursorPro = pkgs.callPackage ./pkgs/xcursor-pro/package.nix {
    source = cursorSources.xcursor-pro;
  };

  everforestVscode = pkgs.callPackage ./pkgs/everforest/vscode/package.nix { };

  rosePineFcitx5 = pkgs.callPackage ./pkgs/rose-pine/fcitx5/package.nix {
    source = rosePineSources.fcitx5;
  };

  rosePineGtk = pkgs.callPackage ./pkgs/rose-pine/gtk/package.nix {
    source = rosePineSources.gtk;
  };

  catppuccinSwaync =
    let
      version = "1.0.1";
      artifactHashes = {
        "frappe.css" = "sha256-CZezkBA43opa0aYggbCwxgqQVCBgRpLsRB0kWzP7oio=";
        "latte.css" = "sha256-nOaSeCxL0ah4eGDFNgNC7mWMTHW6Z5MoQx9XJbvkoac=";
        "macchiato.css" = "sha256-jN7oHf075g463+pPtiTJl3OTXMQjQ+O+OS8L4cCTipI=";
        "mocha.css" = "sha256-EKTAKCU9HlxrrVjNhyMRq7WGfz8DM9IFPUIEGl3nHbo=";
      };
    in
    pkgs.linkFarm "catppuccin-swaync-${version}" (
      lib.mapAttrs (
        artifactName: hash:
        pkgs.fetchurl {
          url = "https://github.com/catppuccin/swaync/releases/download/v${version}/catppuccin-${artifactName}";
          inherit hash;
        }
      ) artifactHashes
    );

  nixporn = {
    bibata = {
      hyprcursor = bibataHyprcursor;
      xcursor = bibataXcursor;
    };

    catppuccin = catppuccinSources // {
      cursors = catppuccinCursors;
      fcitx5 = catppuccinFcitx5;
      gtkPackage = catppuccinGtk;

      gitea = pkgs.fetchzip {
        url = "https://github.com/catppuccin/gitea/releases/download/v1.0.2/catppuccin-gitea.tar.gz";
        hash = "sha256-rZHLORwLUfIFcB6K9yhrzr+UwdPNQVSadsw6rg8Q7gs=";
        stripRoot = false;
      };
      swaync = catppuccinSwaync;
    };

    dracula = draculaSources;
    cyberdream = cyberdreamSource // {
      cursors = xcursorPro;
    };
    decay = decaySources // {
      cursors = pkgs.phinger-cursors;
    };
    everforest =
      everforestSource
      // everforestTargets
      // {
        cursors = pkgs.everforest-cursors;
        gtk = pkgs.everforest-gtk-theme;
        nvim = everforestSource;
        vscodeExtension = everforestVscode;
      };
    gruvbox = {
      nvim = gruvboxSource;
      contrib = gruvboxContribSource;
      cursors = googleCursor;
    };
    kanagawa = kanagawaSource // {
      cursors = pkgs.vimix-cursors;
    };
    nordic = nordicSource;
    rose-pine = rosePineSources // {
      cursors = rosePineCursors;
      fcitx5 = rosePineFcitx5;
      gtk = rosePineGtk;
    };
    spicetify = {
      catppuccin = extraSources.catppuccin-spicetify;
      dracula = extraSources.dracula-spicetify;
      tokyonight = extraSources.tokyonight-spicetify;
    };
    solarized-osaka = solarizedOsakaSource // {
      cursors = xcursorPro;
    };
    tokyonight = tokyonightSource;
  };
in
{
  inherit nixporn;

  packages = { };

  pkgs = {
    inherit nixporn;
  };

  shell = import ./shell.nix { inherit pkgs; };
}
