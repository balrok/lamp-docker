#shellcheck shell=bash

Describe 'Validate sourcing env.sh' # example group
	It 'prints a help text'
		# find() {
		# 	printf '%s\0' 'some_cluster'
		# }
		# docker() {
		# 	printf '%s\n' 'Output from Kubeval tool'
		# 	return 0
		# }
		When run bash -c 'source ../env.sh'
		The status should be success
		The output should match pattern '*dmysqldump*'
		The output should match pattern '*dmysql_create*'
		The output should match pattern '*dmysqlp*'
		The output should match pattern '*dlamp*'
	End
End
