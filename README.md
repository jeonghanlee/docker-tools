# Collection Tools for Docker Usages

![Linter Run](https://github.com/jeonghanlee/docker-tools/workflows/Linter%20Run/badge.svg)

## `docker_shell.bash`

```bash
source docker_shell.bash
```

* `xDockerImagesDelete` is alias of the following command:

```bash
docker rmi -f $(docker images -a -q)
```

* `xDockerPruneAll` is alias of the following command:

```bash
docker system prune -a --volumes
```

* `xDockerPrune` is alias of the following command:

```bash
docker system prune
```

* `xDockerRun $name $options` is alias of the following command:

```bash
xDockerRun channelfinder -d
```

```bash
docker run --network=host ${options} --rm --name="$name"  jeonghanlee/"$name":latest
```

* `xDockerPull $name` is alias of the following command:

```bash
docker pull jeonghanlee/"$name":latest
```

* `xDockerLastIdIn`

```bash
xDockerLastIdIn eb59f9c86930 "--entrypoint" "/bin/sh" "-v" "$HOME/docker_data:/data"
```

## `push_to_hub.bash`

* One can override the default target name via an available options `-n` in push_to_hub or a local file

```bash
echo "TARGET_NAME=recsync" > docker_target_name.local
```

If one use both methods, the option `-n` is used.

```bash
Usage    : ./push_to_hub.bash [-s IMAGE ID] [-t Release Version] <-u docker hub username> <t docker taget name> <-p>

               -s : Docker IMAGE ID
               -t : Desired Release Version
               -n : Target name (default:recsync)
               -u : Docker HUB user name (default:jeonghanlee)
               -p : Push the docker hub (need to do push)

 ---- Dry run (Default)
 $ bash ./push_to_hub.bash -s "04ac57cc7c72" -t "4-v0.1.0"

 ---- Push it to docker hub
 $ bash ./push_to_hub.bash -s "04ac57cc7c72" -t "4-v0.1.0" -p
```

## Check an image id, which one would like to do tag

```bash
docker ps
```

## Login the docker hub

```bash
docker login
```

### Create tag and push

The first argument is `IMAGE ID`, the second one is a version. Then one has the following tag
`jeonghanlee/recsync:1-v0.1.0`

* Dry-run

```bash
bash docker/scripts/push_to_hub.bash -s "24924741269d" -t "recsync:1-v0.1.0"
```

* Push

```bash
bash docker/scripts/push_to_hub.bash -s "24924741269d" -t "recsync:1-v0.1.0" -p
```

### Pull the image from docker hub

```bash
docker pull jeonghanlee/recsync:1-v0.1.0
```
