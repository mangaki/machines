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
    lib = flakes.nixpkgs.lib.extend (final: prev: {
      nixosSystem = { ... }@args: prev.nixosSystem (args // {
        specialArgs = args.specialArgs // {
          inputs = flakes;
          profilesPath = toString "${self}/profiles";
        };

        modules = args.modules ++ builtins.attrValues self.nixosModules;
      });
    } // (import ./lib.nix final prev));
  in
  {
    nixosModules = lib.importDir ./modules;
    nixopsConfigurations.default = { nixpkgs = nixpkgs // { inherit lib; }; } //
    (import ./network.nix flakes);
  };
}
