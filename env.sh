#!/bin/bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

exampleYml="$SCRIPT_DIR/docker-compose-example.yml"

getComposeYamls() {
    feedback="$1"
    composeYamls=""
    for yml in "$SCRIPT_DIR"/data/docker-compose-*.yml; do
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
echo "Following commands can be used now:"

getComposeYamls "true"
composeYamls="$(getComposeYamls)"
# we want to expand the variable here
# shellcheck disable=SC2139
alias dlamp="docker-compose -f $SCRIPT_DIR/docker-compose.yml ${composeYamls}"

echo "* dmysql: You can use this command to directly access the mysql console"
echo "  E.g. 'dmysql' or 'dmysql my_db'"
dmysql() {
    (
        cd "$SCRIPT_DIR" || exit 1
        dlamp exec db mysql -uroot -p"$(_getMysqlRootPw)" "$1"
    )
}

echo "* dmysqlp: Like dmysql but you can pipe into this command"
echo "  E.g. 'echo \"select 1;\" |  dmysqlp' or 'dmysqlp < backup.sql'"
echo "  or 'echo \"select 1;\" |  dmysqlp my_db'"
dmysqlp() {
    dlamp exec -T db mysql -uroot -p"$(_getMysqlRootPw)" "$1" < /dev/stdin
}

echo "* dmysql_create: will create database+user with same name. Will update the pw if db+user already exists"
echo "  E.g. 'dmysql_create db_name [password]'"
dmysql_create() {
    if [[ -z "$1" ]]; then
        echo "Usage $0 db_name [password]"
        exit 1
    fi
    if [[ -n "$2" ]]; then
     PW="$2"
    else
     PW=$(openssl rand -base64 26)
     PW=${PW::-4} # remove last 4 characters - often they are base64 padding
    fi
    echo "Database: $1"
    echo "User: $1"
    echo "Password: $PW"
    echo "CREATE DATABASE IF NOT EXISTS $1 CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;\
          CREATE USER IF NOT EXISTS '$1'@'localhost' IDENTIFIED BY '$PW';\
          ALTER USER '$1'@'localhost' IDENTIFIED BY '$PW';\
          GRANT ALL PRIVILEGES ON $1.* TO '$1'@'localhost';\
          FLUSH PRIVILEGES;" | dmysqlp
}

echo "* dmysqldump: creates a mysqldump"
echo "  E.g. 'dmysqldump my_db > db.sql'"
dmysqldump() {
    dlamp exec -T db mysqldump -uroot -p"$(_getMysqlRootPw)" "$1"
}

_getMysqlRootPw() {
    (
        cd "$SCRIPT_DIR" || exit 1
        grep DB_PW .env | sed "s/DB_PW=//"
    )
}

# TODO alias for adminer start/stop
# TODO alias for mysql create db + user + password
# TODO alias for mysql import, export
