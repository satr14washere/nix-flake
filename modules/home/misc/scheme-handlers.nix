{ pkgs, ... }:
let
  ferium-installer-script = pkgs.writeShellScript "ferium-installer" ''
    mod=$(echo "$1" | awk -F'/' '{print $NF}')
    ${pkgs.kitty}/bin/kitty sh -c "ferium add $mod; read"
  '';
in
{
  xdg.desktopEntries."ferium-installer" = {
    name = "Intercept Modrinth Links to Ferium";
    exec = "${ferium-installer-script} %u";
    mimeType = [ "x-scheme-handler/modrinth" ];
  };

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/modrinth" = "ferium-installer.desktop";
  }; 
}