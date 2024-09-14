{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    babylon-node-nix.url = "github:Krulknul/babylon-node-nix/add-example-for-usage-with-the-colmena-deployment-tool";
    sops-nix.url = "github:Mic92/sops-nix/f30b1bac192e2dc252107ac8a59a03ad25e1b96e";
  };
  outputs =
    {
      nixpkgs,
      babylon-node-nix,
      sops-nix,
      ...
    }:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "x86_64-darwin"
          "aarch64-linux"
          "aarch64-darwin"
        ] (system: function nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell { buildInputs = with pkgs; [ colmena ]; };
      });
      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);

      colmena = {
        meta = {
          nixpkgs = import nixpkgs { system = "x86_64-linux"; };
        };
        # Here's one host, but you can add more hosts with different names.
        # For the SSH credentials, it finds a host with the same name in the SSH config file in this directory.
        host-b = {
          # Colmena-specific configuration related to the deployment
          deployment.buildOnTarget = true;

          imports = [
            babylon-node-nix.nixosModules.babylon-node
            sops-nix.nixosModules.sops
            ./config/configuration.nix
          ];
        };
      };
    };
}
