{ lib }:
{
  settingsFor = cfg: themeName: {
    enabledThemes = [ themeName ];
    transparent = lib.mkDefault cfg.transparent;
    frameless = lib.mkDefault cfg.transparent;
  };

  withTransparentCss =
    cfg: css:
    css
    + lib.optionalString cfg.transparent ''

      :root,
      .theme-light,
      .theme-dark {
        --background: transparent !important;
        --background-primary: transparent !important;
        --bg-base-primary: transparent !important;
        --background-mobile-primary: transparent !important;
        --home-background: transparent !important;
        --chat-background: transparent !important;
        --chat-input-container-background: transparent !important;
      }

      body,
      #app-mount {
        background: transparent !important;
      }
    '';
}
