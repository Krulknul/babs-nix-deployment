{
  config,
  nixpkgs-unstable,
  pkgs,
  ...
}:
{

  # Create a user and group for Alloy
  users.users.alloy = {
    isSystemUser = true;
    group = "alloy";
  };
  users.groups.alloy = {};

  # Enable the Alloy service
  services.alloy.enable = true;

  # The alloy service doesn't allow us to set the user through its options,
  # so we have to set it through systemd directly.
  systemd.services.alloy.serviceConfig.User = "alloy";

  # To configure Grafana Alloy, we must use a configuration file.
  # To insert some secrets and other values into the configuration file,
  # we use the `substituteAll` function from Nixpkgs.
  # The `substituteAll` function takes a src (the file to substitute),
  # and a set of key-value pairs to substitute into the file.
  # The values will be substituted into the file at the corresponding keys surrounded by `@`.
  # For example, if we have a key-value pair `foo = "bar"`,
  # then the string `@foo@` in the file will be replaced with `bar`.
  environment.etc."alloy/config.alloy".source = pkgs.substituteAll {
    src = ./config.alloy;
    metrics_username_file = config.sops.secrets."grafana/metrics/username".path;
    metrics_url_file = config.sops.secrets."grafana/metrics/url".path;
    logs_username_file = config.sops.secrets."grafana/logs/username".path;
    logs_url_file = config.sops.secrets."grafana/logs/url".path;
    password_file = config.sops.secrets."grafana/apiToken".path;

    # The `hostname` is used in the configuration file to set the hostname of the server.
    # It's also possible to let Alloy determine the hostname, but the hostname
    # is only updated after a reboot, so it's better to just set it based on the
    # system configuration, which will make it update immediately.
    hostname = config.networking.hostName;
    prometheus_bind_address = config.services.babylon-node.config.api.prometheus.bind_address;
    prometheus_port = config.services.babylon-node.config.api.prometheus.port;
  };
}
