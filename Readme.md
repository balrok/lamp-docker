# Docker

This project is a docker-compose based solution to host multiple
php files on a single server.

Goals:
* good tradeoff between resource usage and isolation
* extendable setup
	* each webpage should have only 1 configuration file (docker-compose)
* extra easy deployment for common use-cases:
	* static filehosting
	* yii
	* wordpress

## HowTo

Copy `./docker-compose-example.yml` to `./data/docker-compose-mysite.yml` and edit the file to your needs.
Whenever you add another webpage, you just copy the example.

Afterwards run `source env.sh` and you have the command `dlamp` in place for `docker-compose`.


## Architecture

### Database

* MariaDb
* instantiate it **once**, because it requires a lot of ram
* [ ] TODO: isolate each project to one database with one user
	* **current state** just the root-user - extra databases have to be created manually
	* [ ] script/env-variable for db,user,password
* [ ] TODO: simple way to import - probably exists already

### PHP

* PHP-FPM
	* using a debian-base image for the container, because the php-fpm image is complicated to add modules
	* figure out all the required plugins
* instantiate it **once**, because it requires a lot of ram

### Webserver

* nginx
* instantiate it **per webpage**
	* few ram
	* customization for the routes - e.g. yii/wordpress/other have different requirements

### TODO

* [ ] integrate with traefik v2
* [ ] script to create user and db
* [ ] script to backup
	* db: create a dump
	* all other, just rsync the `./data` directory
