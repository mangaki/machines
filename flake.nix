{
  inputs = {
    nixos.url = "flake:nixpkgs/nixos-20.09";
    nixos-unstable.url = "flake:nixpkgs/nixos-unstable";
    dns = {
      url = "github:kirelagin/nix-dns";
      inputs.nixpkgs.follows = "nixos";
    };
    mangaki = {
      url = "github:mangaki/mangaki/raito-nixos";
      inputs.nixpkgs.follows = "nixos";
    };
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixos";
    };
  };

  outputs = flakes @ { self, nixpkgs, nixos, nixos-unstable, dns, mangaki, simple-nixos-mailserver }: 
  let
    lib = flakes.nixos.lib.extend (final: prev: {
      nixosSystem = { ... }@args: args // prev.nixosSystems {
        specialArgs = args.specialArgs // {
          inputs = flakes;
          profilesPath = toString "${self}/profiles";
        };

        modules = args.modules ++ builtins.attrValues self.nixosModules;
      };
    } // (import ./lib.nix));
  in
  {
    nixosModules = lib.importDir ./modules;
    nixopsConfiguration.default = { inherit nixpkgs; } //
    (import ./network.nix flakes);
  };
}
