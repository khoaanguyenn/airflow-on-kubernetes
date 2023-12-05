kind delete cluster --name kind
docker rm $(docker stop $(docker ps -a -q --filter ancestor=registry:2 --format="{{.ID}}"))