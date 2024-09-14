{ config, ... }:
{
  # Create a "babylon-node" user to run the process as
  users.users.babylon-node = {
    isNormalUser = true; # Give the user a home directory to allow node to store some files there
    group = "babylon-node"; # Add the user to the group
    home = "/home/babylon-node";
  };

  # Add a group corresponding to the user
  users.groups.babylon-node = { };

  # Enable the babylon-node service
  services.babylon-node.enable = true;

  # Configure the service.
  services.babylon-node.config = {
    db.location = "/home/babylon-node/db";
    node.key = {
      path = config.sops.secrets."babylon-node/keystore.ks".path;
    };
    run_with.keystore_password_file = config.sops.secrets."babylon-node/keystorePassword".path;
  };
}
