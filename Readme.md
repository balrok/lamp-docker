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
* same setup for development and production

## HowTo

* Copy `./docker-compose-example.yml` to `./data/docker-compose-mysite.yml` and edit the file to your needs.
  * Whenever you add another webpage, you just copy the example.
* Copy `env.example` to `.env` and adjust the values there
* Afterwards run `source env.sh` and you have the command `dlamp` in place for `docker-compose`.
  * now you can run, e.g., `dlamp up -d`


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

* [ ] !!! integrate with traefik v2
  * high priority, but not a blocker
* [x] !! script to create user and db
* [x] ! script to apply db backup
* [ ] script to backup
  * [x] db: create a dump
  * all other, just rsync the `./data` directory
* [ ] integration test
  * source env.sh
  * dlamp up -d
  * curl ...
  * dlamp down
* [ ] autocomplete for dlamp

## Related Work

Most of the related work is in the end not so much related. Nearly all projects focus on a development environment.

- https://github.com/sprintcube/docker-compose-lamp - single environment
- https://github.com/cytopia/devilbox - maybe exactly the same
- https://github.com/lando/lando - maybe exactly the same
- https://github.com/drud/ddev/
