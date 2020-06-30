Collection Tools for Docker Usages
==

# push_to_hub

* One can override the default target name via an available options `-n` in push_to_hub or a local file 
```
echo "TARGET_NAME=recsync" > docker_target_name.local
```
If one use both methods, the option `-n` is used. 



```
Usage    : ./push_to_hub [-s IMAGE ID] [-t Release Version] <-u docker hub username> <t docker taget name> <-d>

               -s : Docker IMAGE ID
               -t : Desired Release Version
               -n : Target name (default:recsync)
               -u : Docker HUB user name (default:jeonghanlee)
               -d : Dry run

 bash ./push_to_hub -s "04ac57cc7c72" -t "4-v0.1.0" 

```


## Check an image id, which one would like to do tag

```
docker ps
```

## Login the docker hub

```
docker login
```

### Create tag and push

The first argument is `IMAGE ID`, the second one is a version. Then one has the following tag
`jeonghanlee/recsync:1-v0.1.0`

```
bash docker/scripts/push_to_hub -s "24924741269d" -t "recsync:1-v0.1.0"
```

### Pull the image from docker hub
```
docker pull jeonghanlee/recsync:1-v0.1.0
```
