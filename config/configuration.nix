{
  config,
  pkgs,
  modulesPath,
  ...
}:
{
  # We have to include the other modules here to apply them.
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"
    ./grafana.nix
    ./babylon-node.nix
    ./secrets.nix
  ];

  # Install a few useful packages (see https://search.nixos.org/packages for more)
  environment.systemPackages = with pkgs; [
    vim
    htop
    git
    magic-wormhole # A secure way to transfer files between hosts
    tree # A handy command to display directory structure
  ];

  # We need to enable these experimental features
  # for some features of NixOS - like flakes - to work
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.firewall = {
    enable = true;
    allowPing = true; # Allows ICMP echo requests
    allowedTCPPorts = [
      22
      30000
    ]; # Allow the SSH port and the default Babylon node gossip port
  };

  # SSH should already be enabled by default,
  # but let's explicitly set the port to 22 here.
  services.openssh.ports = [ 22 ];

  # system.stateVersion is an important variable that ensures compatibility between versions of some stateful services.
  # Read more here: https://search.nixos.org/options?show=system.stateVersion&query=system.StateVersion
  system.stateVersion = "24.11";
}
