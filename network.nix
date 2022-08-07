{ self, nixpkgs, ... }:
{
  network.description = "Mangaki's NixOps machines description";
  network.storage.memory = {};
  defaults = {
    security.acme.acceptTerms = true;
    security.acme.defaults.email = "ryan@mangaki.fr";

    imports = [
      ({
        deployment.targetUser = "raito";
        system.configurationRevision = if (self ? rev) then self.rev else throw "Refusing to deploy from a dirty Git tree, commit your changes!";
        nixpkgs.overlays = [ ];
      })
    ];
  };

  tsukasa = import ./hosts/tsukasa.nix;
}
