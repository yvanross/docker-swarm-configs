export PATH=~/bin:$PATH
export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock
export UID=$(id -u)
export HOSTIP=$(hostname -I)