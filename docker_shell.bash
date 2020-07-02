

function xDockerImagesDelete
{
    local images=$(docker images -a -q)
    docker rmi -f "$images"
}


function xDockerPruneAll
{
    docker system prune -a --volumes
}


function xDockerPrune
{
    docker system prune
}

function xDockerRun
{
    local name="$1"; shift;
    local OPTS=( "$@" ); shift;

    if [ -z "${name}" ]; then
        printf "The first argument should be defined as name\n";
    else    
        docker run --network=host ${OPTS[@]} --rm --name="$name"  jeonghanlee/"$name":latest
    fi
}

function xDockerPull
{
    local name="$1"; shift;
    docker pull jeonghanlee/"$name"
}

