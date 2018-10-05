#!/bin/bash

# PATHS
# Get current working directory
current_dir=`pwd`

# Get the absolute path of where script is running from
script_dir=""

# DESCRIPTION:
#	Resolves the running script directory
#
resolve_script_dir() {
	SOURCE="${BASH_SOURCE[0]}"
	while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
		DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
		SOURCE="$(readlink "$SOURCE")"
		# if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
		[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
	done
	script_dir="$( cd -P "$( dirname "$SOURCE" )" >/dev/null && pwd )"
}

resolve_script_dir
script_path="$script_dir/automentor.bash"

# Commands
src_dir=$script_dir
nightwatch="$script_dir/../node_modules/nightwatch/bin/nightwatch"

# RETURN VARIABLE
ret=""

# ARGUMENTS
args="${@:2}" # All arguments except the first

# DESCRIPTION:
#	Where execution starts
#
main() {
    case $1 in
		*requests* )
			requests
		;;
		*watch* )
			watch
		;;
		*login* )
			login
		;;
		*setup* )
			setup
		;;
		* )
			help
		;;
	esac

    exit 0
}

# DESCRIPTION:
#	displays help menu
#
help() {
	displayln "automentor help menu"
	echo "Usage: automentor [options [values]]"
	echo "[OPTIONS] :"
	echo " setup                         - set up script to be avcailable system wide"
	echo " login                         - open codementor login page so that sessionc can be saved"
	echo " requests [-c count] [-t tags] - show a list of last n requests"
	echo " watch [-s seconds] [-t tags]  - watch the using the tags you provided"
	echo ""
}

# DESCRIPTION:
#	Sets up the script by making it excutable and available system wide
#
setup() {
	display "Make script executable"
	chmod u+x $script_path

	display "Drop a link to it in /usr/local/bin"
	ln -s $script_path /usr/local/bin/automentor
}

# DESCRIPTION:
#	Allows user to login so that session information can be saved
#
# USAGE:
#	automentor login
login() {
	cd $src_dir/..
    $nightwatch --test $src_dir/login.js
}

# DESCRIPTION:
#	Shows the last n requests. 20 is the default
#
# USAGE:
#	automentor requests [-c count] [-t tags]
requests() {
	# Check that cookies is available to start a session
	check_cookies

	# Pass information through environment variable to the application
	get_flag_value -c; return=$ret
	if [[ ! -z $return ]]; then
		echo $return
		export COUNT=$return
	fi

	get_flag_value -t multiple; return=$ret
	if [[ ! -z $return ]]; then
		echo $return
		export TAGS=$return
	fi

	cd $src_dir/..
    $nightwatch --test $src_dir/getRequests.js
}

# DESCRIPTION:
#	Watches and notifies when there is a new request
#
# USAGE:
#	automentor watch [-s seconds] [-t tags]
watch() {
	local return=""
	# Check that cookies is available to start a session
	check_cookies

	# Pass information through environment variable to the application
	get_flag_value -s; return=$ret
	if [[ ! -z $return ]]; then
		export SECONDS=$return
	fi

	get_flag_value -t multiple; return=$ret
	if [[ ! -z $return ]]; then
		export TAGS=$return
	fi

	cd $src_dir/..
    $nightwatch --test $src_dir/watchChanges.js
}

# DESCRIPTION:
#	Checks if cookies are available
check_cookies() {
	if [[ ! -f $src_dir/cookies.js ]]; then
		echo "You need to login first!"
		echo "You can login with: automentor login"
		exit 1
	fi
}


# == HELPER FUNCTIONS == #

# DESCRIPTION:
#	Gets the value following a flag
#
get_flag_value() {
	local value=''
	if [[ $2 == multiple ]]; then
		value=$(echo $args | awk -F"$1" '{print $2}' | awk -F'-' '{print $1}')
	else
		value=$(echo $args | awk -F"$1" '{print $2}' | awk '{print $1}')
	fi

	# Check if there is a valid value after the flag
	if [[ ! -z $value ]]; then
		ret=$value
	else
		ret=""
	fi
}

# TODO: return a number that can be checked fo
# DESCRIPTION:
#	Asks the user for confirmation before proceeding
#
confirm() {
	printf "\n::: Are you sure you want to $1? [Y/n] "

	read response

	if [[ $response = "Y" ]]; then
		return 1
	else
		return 0
	fi
}

# DESCRIPTION:
#	A custom print function
#
display() {
	printf "::: $1 :::\n"
}


# DESCRIPTION:
#	A custom print function that starts its output with a newline
#
displayln() {
	printf "\n::: $1 :::\n"
}


main $@
