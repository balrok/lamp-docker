#!/bin/sh

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
		echo "You can now use the alias 'dlamp' in place of 'docker-compose' to run it with '${composeYamls}'"
		echo "E.g. 'dlamp up -d' or 'dlamp logs -f'"
		echo "Or alternatively docker-compose -f docker-compose.yml ${composeYamls} up -d"
	else
		echo "${composeYamls}"
	fi
}

getComposeYamls "true"
composeYamls="$(getComposeYamls)"
# we want to expand the variable here
# shellcheck disable=SC2139
alias dlamp="docker-compose -f docker-compose.yml ${composeYamls}"

# TODO alias for adminer start/stop
# TODO alias for mysql create db + user + password
# TODO alias for mysql import, export
