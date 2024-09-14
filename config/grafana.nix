{ config, ... }:
{
  services.grafana-agent = {
    enable = true;
    settings = import ./grafana-agent.nix {
      inherit config;
      hostname = "nixos-test";
      nodeJob = "nixos-test";
    };
    credentials = {
      LOGS_REMOTE_WRITE_PASSWORD = config.sops.secrets."grafana/logs/password".path;
      LOGS_REMOTE_WRITE_USERNAME = config.sops.secrets."grafana/logs/username".path;
      LOGS_REMOTE_WRITE_URL = config.sops.secrets."grafana/logs/url".path;
      METRICS_REMOTE_WRITE_PASSWORD = config.sops.secrets."grafana/metrics/password".path;
      METRICS_REMOTE_WRITE_USERNAME = config.sops.secrets."grafana/metrics/username".path;
      METRICS_REMOTE_WRITE_URL = config.sops.secrets."grafana/metrics/url".path;
    };
  };
}
