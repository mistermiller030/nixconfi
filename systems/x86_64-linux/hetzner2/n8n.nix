{ ... }:
{
  services.n8n = {
    enable = true;
    openFirewall = true;
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "n8n.david.ritter.family" = {
        useACMEHost = "n8n.david.ritter.family";
        locations."/" = {
          proxyPass = "http://127.0.0.1:5678";
          recommendedProxySettings = true;
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "beneritter@gmail.com";
    certs."n8n.david.ritter.family" = {
      # An acme system user is created. This user belongs to the acme group and the home directory is /var/lib/acme.
      # This user will try to make the directory .well-known/acme-challenge/ under the webroot directory.
      webroot = "/var/lib/acme";
    };
  };

  users.users.nginx.extraGroups = ["acme"];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

}
