{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    babylon-node-nix.url = "github:Krulknul/babylon-node-nix/add-example-for-usage-with-the-colmena-deployment-tool";
    sops-nix.url = "github:Mic92/sops-nix/f30b1bac192e2dc252107ac8a59a03ad25e1b96e";
  };
  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
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
      # The devShells attribute is used to create development environments for the project.
      # This development environment includes colmena, which is the CLI tool used for the deployment.
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell { buildInputs = with pkgs; [ colmena ]; };
      });
      # The default formatter used when running `nix fmt` in the project.
      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);

      colmena = {
        meta =
          let
            system = "x86_64-linux";
            unstable = import nixpkgs-unstable { inherit system; };
          in
          {
            # The new Grafana Alloy service is only available in the unstable channel,
            # meaning we'll have to create an overlay. This overlay is used to add the
            # Grafana Alloy service to the stable channel that we're using.
            nixpkgs = import nixpkgs {
              inherit system;
              overlays = [ (final: prev: { grafana-alloy = unstable.grafana-alloy; }) ];
            };
            # Pass the unstable channel as a specialArg so we can import the Alloy service module
            # in the configuration.nix file.
            specialArgs = {
              inherit nixpkgs-unstable;
            };
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
