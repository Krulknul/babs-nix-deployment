# Uses sops-nix (https://github.com/Mic92/sops-nix) to make secrets available on the host.
# In a nutshell, it works like this:
# - The secrets are encrypted using sops (https://github.com/getsops/sops) with
#   the host's public key.
# - The encrypted secrets are transferred to the host.
# - The host decrypts the secrets using its private key on every boot, making
#   them available in the file system (using an in-memory file system - tmpfs).

{
  # The path to the default "sops" file, which contains encrypted secrets.
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  # The path (on the host) to the private key used to decrypt the secrets.
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # The secrets that should be decrypted and made available on the host.
  sops.secrets =
    let
      grafanaSecretSettings = {
        # Make sure the service is restarted when the secret changes
        restartUnits = [ "alloy" ];
        owner = "alloy";
        group = "alloy";
      };
    in
    {
      # This makes the secret available in /run/secrets/grafana/metrics/username
      # It follows the same structure as the sops yaml file.
      "grafana/metrics/url" = grafanaSecretSettings;
      "grafana/metrics/username" = grafanaSecretSettings;
      "grafana/logs/url" = grafanaSecretSettings;
      "grafana/logs/username" = grafanaSecretSettings;
      "grafana/apiToken" = grafanaSecretSettings;

      "babylon-node/keystorePassword" = {
        # Make sure the service is restarted when the secret changes
        restartUnits = [ "babylon-node" ];
        owner = "babylon-node";
        group = "babylon-node";
      };

      "babylon-node/keystore.ks" = {
        restartUnits = [ "babylon-node" ];
        sopsFile = ../secrets/keystore.ks;
        # Usually in sops-nix we use yaml or json files, but this
        # is a binary file, so we need to specify the format.
        # To encrypt it with sops you could use: sops --encrypt --in-place keystore.ks
        format = "binary";
        owner = "babylon-node";
        group = "babylon-node";
      };
    };
}
