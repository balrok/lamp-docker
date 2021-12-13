build_nginx:
	docker build -t balrok_nginx -f Dockerfile.nginx .

build_php:
	docker build -t balrok_php -f Dockerfile.php .

build: build_php build_nginx
