# Configuration docker-compose avec traefik et portainer

ssh cc-yross@your_domain
pass: ChangeMeNow
Changer le mot de passe avec la commande
```
passwd
```

## Connection au serveur virtuel
ssh docker@YOUR_DOMAIN
Changer le mot de passe avec la commande
```
passwd
```

## Étapes
1. Docker installé en *rootless* et docker-compose
```
su cc-yross
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo 'net.ipv4.ip_unprivileged_port_start=80' | sudo tee -a /etc/sysctl.conf
sudo sysctl --system
exit
```

1. Configurer les variables d'environnement (`~/.config/environment.d/10-docker.conf`):
   
```
id -u docker # pour obtenir le USER_UID
mkdir -p ~/.config/environment.d
read -p "3 dernier chiffre de l'adress ip: " adresseip || return
echo $adresseip 
echo "DOMAIN=10.194.33."$adresseip".nip.io"  | tee -a ~/.config/environment.d/10-docker.conf
echo 'DOCKER_HOST=unix:///run/user/1003/docker.sock' | tee -a ~/.config/environment.d/10-docker.conf
vim ~/.config/environment.d/10-docker.conf
```

1. Cloner ce répertoire: `git clone https://github.com/yvanross/docker-swarm-configs.git`

Generate Github personnal access token
https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token

1. Modifier `traefikv2/traefikv2.service` et `portainer/portainer.service` pour que les chemins des répertoires correspondent à votre configuration.
```
whereis docker-compose # /usr/local/bin/docker-compose 
cd docker-swarm-configs/
vim traefikv2/traefikv2.service
vim portainer/portainer.service
dockerd-rootless-setuptool.sh install
```
5. configurer les path
```
vim ~/.bashrc
export PATH=/usr/bin:$PATH
export DOCKER_HOST=unix:///run/user/1003/docker.sock
source ~/.bashrc
````

6. Créer des symlinks pour créer les services et redemarrer docker: 
```bash
docker ps
ln -s ~/docker-swarm-configs/portainer/portainer.service ~/.config/systemd/user/portainer.service
ln -s ~/docker-swarm-configs/traefikv2/traefikv2.service ~/.config/systemd/user/traefikv2.service
systemctl --user restart docker.service
```
5. Ouvrir session screen et démarrer docker:
```
screen
systemctl --user start docker.service
```

6. Créer le network externe:
```bash
docker network create traefik_public
```

7. Démarrer les services:

```bash
systemctl --user daemon-reload
systemctl --user start traefikv2.service
systemctl --user start portainer.service
docker ps # pour vérifier si les serveurs sont démarrés

# Si les variables d'environnement sont mis après avoir configurer les services

# pour arrèter
systemctl --user stop portainer.service
```
autre option pour le démarrage
```
screen
cd ~/docker-swarm-configs/traefikv2
cmd="DOMAIN=10.194.33.$adresseip.nip.io docker-compose up"
echo $cmd
eval $cmd
ctrl a d
screen
cd ~/docker-swarm-configs/portainer
cmd="DOMAIN=10.194.33.$adresseip.nip.io docker-compose up"
echo $cmd
eval $cmd
ctrl a d
docker ps
```

8. Detacher de screen en conservant la session active: `ctrl a d`

9. Vous avez maintenant accès à traefik via `http://traefik.YOUR_DOMAIN.nip.io` et à portainer via `http://portainer.YOUR_DOMAIN.nip.io`
    
    http://traefik.10.194.33.150.nip.io
    http://portainer.10.194.33.150.nip.io

pour détruire tout les screen
```
pkill screen
```

Voir [Portainer configuration](PORTAINER-CONFIG.MD)
Voir [Portainer docker file](docker-compose.md)

# pour débugger
journalctl -xe

pour traefik
Dans folder docker-swarm-configs/traefikv2, rouler:

DOMAIN=1.2.3.4.nip.io docker-compose up
Evidemment le domaine tu mets la vrai valeur, pas 1.2.3.4 


# Toute les commandes

```
sshpass -p password ssh docker@10.194.33.162
su cc-yross 
```
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo 'net.ipv4.ip_unprivileged_port_start=80' | sudo tee -a /etc/sysctl.conf
sudo sysctl --system
exit
```
   
```
id -u docker # pour obtenir le USER_UID
mkdir -p ~/.config/environment.d
read -p "3 dernier chiffre de l'adress ip: " adresseip || return
```
```
echo $adresseip 
echo "DOMAIN=10.194.33."$adresseip".nip.io"  | tee -a ~/.config/environment.d/10-docker.conf
echo 'DOCKER_HOST=unix:///run/user/1003/docker.sock' | tee -a ~/.config/environment.d/10-docker.conf
vim ~/.config/environment.d/10-docker.conf
```
```
git clone https://github.com/yvanross/docker-swarm-configs.git
dockerd-rootless-setuptool.sh install
echo 'export PATH=/usr/bin:$PATH' >> ~/.bashrc
echo 'export DOCKER_HOST=unix:///run/user/1003/docker.sock' >> ~/.bashrc
cat ~/.bashrc
source ~/.bashrc
docker ps
ln -s ~/docker-swarm-configs/portainer/portainer.service ~/.config/systemd/user/portainer.service
ln -s ~/docker-swarm-configs/traefikv2/traefikv2.service ~/.config/systemd/user/traefikv2.service
systemctl --user restart docker.service
docker network create traefik_public  
```
screen
```
read -p "3 dernier chiffre de l'adress ip: " adresseip 
cd ~/docker-swarm-configs/traefikv2
cmd="DOMAIN=10.194.33.$adresseip.nip.io docker-compose up"
echo $cmd
eval $cmd
```

ctrl a d

```
screen
```
```
read -e -p "3 dernier chiffre de l'adress ip: " adresseip 
cd ~/docker-swarm-configs/portainer
cmd="DOMAIN=10.194.33.$adresseip.nip.io docker-compose up"
echo $cmd
eval $cmd
```

ctrl a d

```
docker ps
exit
```

## pour executer un script dans un screen
 #!/bin/sh
screen -S tf2 /full/path/to/startserver.sh