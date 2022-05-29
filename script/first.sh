


if [ -z $1 ] || [ -z $2 ]; then
  echo "install docker-compose"
  echo 'first: admin password'
  echo 'second: last 3 didgit of url'
else 
  sshpass -p $1 ssh cc-yross@10.194.33.$2
  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  echo 'net.ipv4.ip_unprivileged_port_start=80' | sudo tee -a /etc/sysctl.conf
  sudo sysctl --system
  exit
fi