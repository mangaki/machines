flakes:
{
  network.description = "Mangaki's NixOps machines description";
  defaults = {
    security.acme.acceptTerms = true;
    security.acme.email = "ryan@mangaki.fr";

    imports = [
      ({
        system.configurationRevision = flakes.self.rev
          or (throw "Cannot deploy from an unclean source tree!");
        nixpkgs.overlays = [ ];
      })
    ];
  };

  tsukasa = import ./hosts/tsukasa.nix;
}
