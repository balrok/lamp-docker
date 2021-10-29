#!/bin/bash

exampleYml="docker-compose-example.yml"

getComposeYamls() {
	feedback="$1"
	composeYamls=""
	for yml in ./data/docker-compose-*.yml; do
		composeYamls="${composeYamls} -f '${yml}'"
	done
	if [ -z "${composeYamls}" ]; then
		if [ "${feedback}" = "true" ]; then
			echo "You did not yet create any docker-compose-XZY.yml files"
			echo "Using now ${exampleYml}"
		fi
		composeYamls="-f ${exampleYml}"
	fi
	if [ "${feedback}" = "true" ]; then
		echo "* dlamp: You can now use the alias 'dlamp' in place of 'docker-compose' to run it with '${composeYamls}'"
		echo "  E.g. 'dlamp up -d' or 'dlamp logs -f'"
		echo "  Or alternatively docker-compose -f docker-compose.yml ${composeYamls} up -d"
	else
		echo "${composeYamls}"
	fi
}

getComposeYamls "true"
composeYamls="$(getComposeYamls)"
# we want to expand the variable here
# shellcheck disable=SC2139
alias dlamp="docker-compose -f docker-compose.yml ${composeYamls}"

echo "dmysql: You can use this command to directly access the mysql console"
echo "  E.g. 'dmysql'"
dmysql() {
	dlamp exec db mysql -uroot -p"$(grep DB_PW .env | sed "s/DB_PW=//")" "$@"
}

echo "dmysqlp: Like dmysql but you can pipe into this command"
echo "  E.g. 'echo \"select 1;\"  |  dmysqlp' or 'dmysqlp < backup.sql'"

dmysqlp() {
	dlamp exec -T db mysql -uroot -p"$(grep DB_PW .env | sed "s/DB_PW=//")" "$@" < /dev/stdin
}

dmysql_create() {
   if [[ -n "$2" ]]; then
    PW="$2"
   else
    PW=$(openssl rand -base64 26)
    PW=${PW::-4} # remove last 4 characters - often they are base64 padding
   fi
   echo "CREATE DATABASE IF NOT EXISTS $1 CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;\
		 CREATE USER '$1'@'localhost' IDENTIFIED BY '$PW';\
		 GRANT ALL PRIVILEGES ON $1.* TO '$1'@'localhost';\
		 FLUSH PRIVILEGES;" | dmysqlp
}


# TODO alias for adminer start/stop
# TODO alias for mysql create db + user + password
# TODO alias for mysql import, export
