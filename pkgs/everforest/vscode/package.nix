{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "sainnhe";
    name = "everforest";
    version = "0.3.0";
    hash = "sha256-nZirzVvM160ZTpBLTimL2X35sIGy5j2LQOok7a2Yc7U=";
  };

  meta = {
    description = "Everforest color theme for Visual Studio Code";
    homepage = "https://github.com/sainnhe/everforest-vscode";
    license = lib.licenses.mit;
  };
}
