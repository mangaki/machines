{ ... }:
{
  users.users.raito = {
    isNormalUser = true;
    extraGroups = [ "wheels" ];
    initialPassword = "changemechangeme";
  };
}
