# wordpress

88plug/wordpress is a fork of the wordpress:4.9.8-php7.1-apache Docker image.

Included in this fork is apache2, php7.1, mcrypt, redis, memcached, and imagemagick.

Additionally you can run 88plug/wordpress with Traefik to setup easy as 1-2-3!

Before you start ensure your DNS records are pointing at the correct server, this will generate SSL certificates.

git clone https://github.com/88plug/wordpress.git ; cd wordpress
chmod +x ./make_site.sh ; ./make_site.sh

You will be prompted for an email, domain, monitoring domain (for traefik), and a mysql password.

A folder $domain/ will be created with your new configuration.
docker-compose.yml and traefik.toml can be further customized for your domain settings.

If you are using Cloudflare and ./make_site.sh please be sure to use developer mode (disable acceleration) for the original SSL certificate generation.  If you ever get stuck with old SSL certificates, you can re-create acme.json and use restart.sh