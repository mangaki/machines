{ ... }:
{
  users.users.raito = {
    isNormalUser = true;
    extraGroups = [ "wheels" ];
    openssh.authorizedKeys.keyFiles = [ ./raito.keys ];
    initialPassword = "changemechangeme";
  };
  security.sudo.wheelNeedsPassword = false;
  nix.trustedUsers = [ "raito" ];
}
