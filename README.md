# wordpress
WordPress Dockerfile with apache2, php7.1, mcrypt, redis, memcached, and imagemagick 

Use 88plug:wordpress to get access to a pre-compiled version of Wordpress with all the extras.

88plug Wordpress with Traefik setup is easy as 1-2-3!

Before you start ensure your DNS records are pointing at the correct server, this will generate SSL certificates.

git clone https://github.com/88plug/wordpress.git ; cd wordpress
chmod +x ./make_site.sh ; ./make_site.sh ; cd $domain/ ; chmod +x restart.sh
./restart.sh 

You will be prompted for an email, domain, monitoring domain (for traefik), and a mysql password.

docker-compose.yml and traefik.toml will be customized for your domain settings.

A folder $domain/ will be created with your new configuration.

If you are using Cloudflare and ./make_site.sh please be sure to use developer mode (disable acceleration) for the SSL certificates can authenticate.  If you ever get stuck with old SSL certificates, you can re-create acme.json and use restart.sh