{ pkgs, lib, ... }: let
  # Wrap zoom in a systemd scope with a memory cap: Zoom on Linux spikes
  # RAM within seconds when joining a meeting until the system OOMs.
  # The cgroup kill is confined to the scope, so the desktop survives.
  zoom-capped = pkgs.runCommand "zoom-us-capped" { } ''
    mkdir -p $out/bin
    # keep icons (Icon=Zoom), mime types and the rest of share/ from the original package
    cp -rs --no-preserve=mode ${pkgs.zoom-us}/share $out/share
    cat > $out/bin/zoom-us <<'EOF'
    #!${pkgs.runtimeShell}
    # disableCef=true stops ZoomWebviewHost (CEF) from spawning, saves RAM.
    # Set in the launcher since Zoom rewrites zoomus.conf itself.
    conf="$HOME/.config/zoomus.conf"
    mkdir -p "$HOME/.config"
    if [ ! -f "$conf" ]; then
      printf '[General]\ndisableCef=true\n' > "$conf"
    elif ${pkgs.gnugrep}/bin/grep -q '^disableCef=' "$conf"; then
      ${pkgs.gnused}/bin/sed -i 's/^disableCef=.*/disableCef=true/' "$conf"
    elif ${pkgs.gnugrep}/bin/grep -q '^\[General\]' "$conf"; then
      ${pkgs.gnused}/bin/sed -i '0,/^\[General\]/s//[General]\ndisableCef=true/' "$conf"
    else
      printf '[General]\ndisableCef=true\n' >> "$conf"
    fi
    exec ${pkgs.systemd}/bin/systemd-run --user --scope --quiet --collect \
      -p MemoryMax=6G -p MemorySwapMax=0 \
      ${lib.getExe pkgs.zoom-us} "$@"
    EOF
    chmod +x $out/bin/zoom-us
    ln -s zoom-us $out/bin/zoom
    # swap the symlinked desktop entry for one that launches the capped wrapper
    rm $out/share/applications/Zoom.desktop
    substitute ${pkgs.zoom-us}/share/applications/Zoom.desktop $out/share/applications/Zoom.desktop \
      --replace-fail Exec=zoom Exec=zoom-us
  '';
in {
  nixpkgs.config.allowUnfree = true;

  xdg = {
    autostart.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "nvim.desktop";
        "text/html" = "brave-browser.desktop";
        "application/pdf" = "brave-browser.desktop";
        "x-scheme-handler/http" = "brave-browser.desktop";
        "x-scheme-handler/https" = "brave-browser.desktop";
        "x-terminal-emulator" = "kitty.desktop";
        "inode/directory" = "pcmanfm-qt.desktop";
        "audio/mpeg" = "vlc.desktop";
        "audio/mp3" = "vlc.desktop";
        "audio/wav" = "vlc.desktop";
        "audio/flac" = "vlc.desktop";
        "video/mp4" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
        "video/webm" = "vlc.desktop";
        "video/x-msvideo" = "vlc.desktop";
      };
    };
  };
  
  home.packages = with pkgs; [
    zed-editor
    kicad
    opencode
    github-copilot-cli

    slack
    zoom-capped
    vesktop
    
    vlc
    brave
    flameshot
    libreoffice
    appimage-run
    kdePackages.kdenlive

    virt-manager
    remmina
    moonlight-qt
    gpu-screen-recorder
    gpu-screen-recorder-gtk

    # LOCK IN
    (prismlauncher.override {
      jdks = with javaPackages.compiler.temurin-bin; [ jre-21 jdk-25 ];
    })
  ];
}
