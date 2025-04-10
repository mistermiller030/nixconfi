{ ... }:
{
  services.n8n = {
    enable = true;
    openFirewall = true;
  };

systemd.services.n8n.environment.N8N_SECURE_COOKIE = "false";
  services.nginx = {
    enable = true;
    virtualHosts = {
      "n8n.a24-umzuege.de" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:5678";
          recommendedProxySettings = true;
        };
      };
    };
  };


  networking.firewall.allowedTCPPorts = [ 80 443 ];

}
