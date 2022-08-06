{ self, ... }:
{
  network.description = "Mangaki's NixOps machines description";
  network.storage.memory = {};
  #network.storage.legacy = {
  #  databasefile = "./mangaki.nixops";
  #};
  defaults = {
    security.acme.acceptTerms = true;
    security.acme.defaults.email = "ryan@mangaki.fr";

    imports = [
      ({
        # deployment.targetUser = "raito";
        system.configurationRevision = self.rev
          or (throw "Cannot deploy from an unclean source tree!");
        nixpkgs.overlays = [ ];
      })
    ];
  };

  tsukasa = import ./hosts/tsukasa.nix;
}
