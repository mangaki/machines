{
  inputs = {
    nixpkgs.follows = "mangaki/nixpkgs";
    mangaki.url = "github:mangaki/mangaki";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = flakes @ { self, nixpkgs, mangaki, agenix }: 
  let
    lib = flakes.nixpkgs.lib.extend (final: prev: {
      nixosSystem = { ... }@args: prev.nixosSystem (args // {
        specialArgs = (args.specialArgs or {}) // {
          inputs = flakes;
          profilesPath = toString "${self}/profiles";
        };

        modules = args.modules ++ builtins.attrValues self.nixosModules ++ [ agenix.nixosModule ];
      });
    } // (import ./lib.nix final prev));
    supportedSystems = [ "x86_64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
  in
  {
    devShell = forAllSystems (system:
        let
          pkgSet = nixpkgsFor.${system};
        in
        with pkgSet;
        mkShell {
          NIXOPS_STATE = "mangaki.nixops";
          buildInputs = [
            nixopsUnstable
            agenix.defaultPackage.x86_64-linux
          ];
        });

    nixosModules = lib.importDir ./modules;
    nixopsConfigurations.default = { nixpkgs = nixpkgs // { inherit lib; }; } //
    (import ./network.nix flakes);
  };
}
