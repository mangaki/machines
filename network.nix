{ self, nixpkgs, ... }:
{
  network.description = "Mangaki's NixOps machines description";
  network.storage.memory = {};
  defaults = {
    security.acme.acceptTerms = true;
    security.acme.defaults.email = "ryan@mangaki.fr";

    imports = [
      ({
        # deployment.targetUser = "raito";
        # FIXME(Raito): why is this always null
        system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        nixpkgs.overlays = [ ];
      })
    ];
  };

  tsukasa = import ./hosts/tsukasa.nix;
}
