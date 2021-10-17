{ ... }:
{
  users.users.raito = {
    isNormalUser = true;
    extraGroups = [ "wheels" ];
    openssh.authorizedKeys.keyFiles = [ ./raito.keys ];
    initialPassword = "changemechangeme";
  };
}
