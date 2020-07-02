#!/usr/bin/env bash
#
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  date    : Thursday, July  2 01:16:54 PDT 2020
#  version : 0.0.4

declare -gr SC_SCRIPT="$(realpath "$0")";
declare -gr SC_SCRIPTNAME=${0##*/};
declare -gr SC_TOP="${SC_SCRIPT%/*}";

set -a
. ${SC_TOP}/docker_default_target_name.conf
if [ -r ${SC_TOP}/docker_target_name.local ]; then
    printf ">>> We've found the local configuration file.\n";
    printf "    The original TARGET_NAME = %s\n" "${TARGET_NAME}"
    . ${SC_TOP}/docker_target_name.local
    printf "    will be overriden with TARGET_NAME = %s\n\n" "${TARGET_NAME}"
    
fi
set +a


function usage
{
    {
	echo "";
	echo "Usage    : $0 [-s IMAGE ID] <-u docker hub username> <-n docker taget name> [-t Release Version] <-p>"
	echo "";
	echo "               -s : Docker IMAGE ID";
	echo "               -u : Docker HUB user name (default:jeonghanlee)";
	echo "               -n : Target name (default:recsync)";
	echo "               -t : Desired Release Version";
	echo "               -p : Push the docker hub (need to do push) ";
	echo "";
	echo " ---- Dry run (Default)"
	echo " $ bash $0 -s \"04ac57cc7c72\" -t \"4-v0.1.0\" "
	echo "";
	echo " ---- Push it to docker hub"
	echo " $ bash $0 -s \"04ac57cc7c72\" -t \"4-v0.1.0\" -p"
	echo ""
    } 1>&2;
    exit 1;
}



options=":s:t:n:u:p"
DRYRUN="YES";

while getopts "${options}" opt; do
    case "${opt}" in
        s) source_image=${OPTARG}   ;;
        t) target_version=${OPTARG} ;;
	n) target_name=${OPTARG}    ;;
	u) USER_NAME=${OPTARG}      ;;
	p) DRYRUN="NO"             ;;
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
    printf ">>> We will use the predefined target name %s\n" ${TARGET_NAME}
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

if [ "$DRYRUN" == "YES" ]; then
    run_cmd="echo"
else
    docker login
    run_cmd="eval"
fi


printf "\n>>> Tagging....${target_image} at ${source_image}\n";
${run_cmd} "${command1}"
printf "\n>>> Tagging....${target_image_latest} at ${source_image}\n";
${run_cmd} "${command3}"
printf "\n>>> Pushing....${target_image} to hub.docker.com\n";
${run_cmd} "${command2}"
printf "\n>>> Pushing....${target_image_latest} to hub.docker.com\n";
${run_cmd} "${command4}"

