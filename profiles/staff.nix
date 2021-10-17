{ ... }:
{
  users.users.raito = {
    isNormalUser = true;
    extraGroups = [ "wheels" ];
    openssh.authorizedKeyFiles = [ ./raito.keys ];
    initialPassword = "changemechangeme";
  };
}
