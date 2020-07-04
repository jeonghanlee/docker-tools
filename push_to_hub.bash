#!/usr/bin/env bash
#
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  date    : Thursday, July  2 01:16:54 PDT 2020
#  version : 0.0.4

declare -g SC_SCRIPT;
#declare -g SC_SCRIPTNAME;
declare -g SC_TOP;
#declare -g LOGDATE;

SC_SCRIPT="$(realpath "$0")";
#SC_SCRIPTNAME=${0##*/};
SC_TOP="${SC_SCRIPT%/*}"
#LOGDATE="$(date +%y%m%d%H%M)"

set -a
# shellcheck disable=SC1091
# shellcheck source=docker_default_target_name.conf
if [ -r "${SC_TOP}"/docker_target_name.local ]; then
    printf ">>> We've found the local configuration file.\\n";
    printf "    The original TARGET_NAME = %s\\n" "${TARGET_NAME}"
	# shellcheck disable=SC1091
	# shellcheck source=docker_target_name.local
    . "$SC_TOP/docker_target_name.local"
    printf "    will be overriden with TARGET_NAME = %s\\n\\n" "${TARGET_NAME}"
fi
set +a


function prn_tag 
{
	local a="$1"; shift;
	local b="$1"; shift;
	printf "\\n>>> Tagging....%s at %s\\n" "${a}" "${b}";
}

function prn_push 
{
	local a="$1"; shift;
	printf "\\n>>> Pushing...%s at %s\\n" "${a}" "hub.docker.com";
}

function prn
{
	local a="$1"; shift;
	local b="$1"; shift;
	prn_tag "$a" "$b";
	prn_push "$a";
}


function usage
{
    {
	echo "";
	echo "Usage    : $0 [-s IMAGE ID] <-u docker hub username> <-n docker taget name> [-t Release Version] <push>"
	echo "";
	echo "               -s   : Docker IMAGE ID";
	echo "               -u   : Docker HUB user name (default:jeonghanlee)";
	echo "               -n   : Target name (default:recsync)";
	echo "               -t   : Desired Release Version";
	echo "               push : without push, it is dry-run."
	echo "";
	echo " ---- Dry run"
	echo " $ bash $0 -s \"04ac57cc7c72\" -u \"jeonghanlee\" -n \"channelfinder\" -t \"v1.0.1\""
	echo "";
	echo " ---- Push it to hub.docker.com"
	echo " $ bash $0 -s \"04ac57cc7c72\" -u \"jeonghanlee\" -n \"channelfinder\" -t \"v1.0.1\" push"
	echo ""
    } 1>&2;
    exit 1;
}



options=":s:t:n:u:"

while getopts "${options}" opt; do
    case "${opt}" in
        s) 
			source_image=${OPTARG}
			;;
        t) 
			target_version=${OPTARG}
			;;
		n) 
			target_name=${OPTARG}
			;;
		u) 
			USER_NAME=${OPTARG}
			;;
		:)
	    	echo "Option -$OPTARG requires an argument." >&2
	    	usage
	    ;;
		h)
	    	usage
	    ;;
		\?)
	    	echo "Invalid option: -$OPTARG" >&2
	    	usage
	    ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${source_image}" ]; then
    usage;
fi

if [ -z "${target_version}" ]; then
    usage;
fi

if [ -z "${target_name}" ]; then
    printf ">>> We will use the predefined target name %s\\n" "${TARGET_NAME}"
	if [ -z "${TARGET_NAME}" ]; then
	printf "    We cannot find the default one, force to use %s\\n" "recsync"
	TARGET_NAME="recsync"
	fi
else
    TARGET_NAME=${target_name};
fi

if [ -z "${USER_NAME}" ]; then
    USER_NAME="jeonghanlee"
fi




target_image=${USER_NAME}/${TARGET_NAME}:${target_version}
target_image_latest=${USER_NAME}/${TARGET_NAME}:latest

command1="docker tag ${source_image} ${target_image}"
command2="docker push ${target_image}"

command3="docker tag ${source_image} ${target_image_latest}"
command4="docker push ${target_image_latest}"
run_cmd=""

case "$1" in
    push)
	    docker login;
    	run_cmd="eval";
		;;
	*)		
	    run_cmd="echo";
		;;
esac

prn "${target_image}" "${source_image}";
${run_cmd} "${command1}"
${run_cmd} "${command2}"

prn "${target_image_latest}" "${source_image}";
${run_cmd} "${command3}"
${run_cmd} "${command4}"

