{ pkgs, ... }: let
  serverName   = "mc0-explorers-creativity";
  serviceName  = "minecraft-server-${serverName}";
  backupDir    = "/mnt/data/backups/mc";
  keepBackups  = 7;   # number of backups to retain
  rconHost     = "localhost";
  rconPort     = "25575";
  rconPassword = "howdy";
  ntfyUrl      = "http://127.0.0.1:8067";
  ntfyTopic    = "mc-backup";

  backupScript = pkgs.writeShellScriptBin "mc-backup" ''
    set -euo pipefail

    rcon() {
      ${pkgs.rcon-cli}/bin/rcon-cli --address "${rconHost}:${rconPort}" --password "${rconPassword}" "$@" || true
    }

    BACKUP_OK=false

    on_exit() {
      # Always restart the server first
      echo "[mc-backup] Restarting server..."
      systemctl start ${serviceName}.service

      # Notify via ntfy only on failure
      if [ "$BACKUP_OK" != "true" ]; then
        echo "[mc-backup] Sending failure notification..."
        ${pkgs.curl}/bin/curl -s -o /dev/null \
          -H "Title: Minecraft Backup Failed" \
          -H "Priority: high" \
          -H "Tags: warning" \
          -d "Nightly backup failed at $(date '+%Y-%m-%d %H:%M:%S'). Check logs with: journalctl -u mc-backup -n 50" \
          "${ntfyUrl}/${ntfyTopic}"
      fi
    }

    # Always restart the server on exit, even if the script fails mid-backup
    trap on_exit EXIT

    # --- Countdown warnings via RCON ---
    echo "[mc-backup] Sending 5-minute warning..."
    rcon "say §c[Backup] §fServer will restart in §e5 minutes §ffor a scheduled backup."

    sleep 240

    echo "[mc-backup] Sending 1-minute warning..."
    rcon "say §c[Backup] §fServer restarting in §e1 minute§f."

    sleep 50

    echo "[mc-backup] Sending 10-second warning..."
    rcon "say §c[Backup] §fServer restarting in §e10 seconds§f."

    sleep 10

    rcon "say §c[Backup] §fShutting down now. Back shortly!"

    # --- Save world & stop ---
    echo "[mc-backup] Saving world..."
    rcon "save-all"
    sleep 5

    echo "[mc-backup] Stopping ${serviceName}..."
    systemctl stop ${serviceName}.service

    # --- Backup ---
    echo "[mc-backup] Backing up to ${backupDir}..."
    mkdir -p "${backupDir}"
    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
    XZ_OPT="-9e" tar -cJf "${backupDir}/mc-backup-$TIMESTAMP.tar.xz" \
      -C /srv/minecraft ${serverName}

    # Prune old backups, keeping the last ${toString keepBackups}
    ls -t "${backupDir}"/mc-backup-*.tar.xz | tail -n +${toString (keepBackups + 1)} | xargs -r rm --

    echo "[mc-backup] Backup complete: mc-backup-$TIMESTAMP.tar.xz"
    BACKUP_OK=true
    # Server restart is handled by the EXIT trap above
  '';
in {
  environment.systemPackages = [ backupScript ];

  systemd.services.mc-backup = {
    description = "Nightly Minecraft server backup";
    serviceConfig = {
      Type           = "oneshot";
      ExecStart      = "${backupScript}/bin/mc-backup";
      User           = "root";
      StandardOutput = "journal";
      StandardError  = "journal";
    };
  };

  systemd.timers.mc-backup = {
    description = "Nightly Minecraft backup timer";
    wantedBy    = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";   # fires at 00:00:00 every day
      Persistent = true;      # catch up if the machine was off at midnight
    };
  };
}
