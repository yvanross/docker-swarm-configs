# Configuration docker-compose avec traefik et portainer


## Connection au serveur virtuel
ssh docker@YOUR_DOMAIN
Changer le mot de passe avec la commande
```/
passwd
```

## Prérequis

- Docker installé en *rootless* et docker-compose
```
su cc-yross
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
## Étapes

1. Configurer les variables d'environnement (`~/.config/environment.d/10-docker.conf`):
   
```
mkdir -p ~/.config/environment.d
vim ~/.config/environment.d/10-docker.conf
```
Ajouter le texte suivant
```
DOMAIN=YOUR_DOMAIN_HERE.nip.io
DOCKER_HOST=unix:///run/user/YOUR_USER_UID_HERE/docker.sock
```
exemple:
```
DOMAIN=YOUR_DOMAIN.nip.io
DOCKER_HOST=unix:///run/user/YOUR_USER_UID_HERE/docker.sock
```
utiliser la commande suivante pour obtenir le docker user id:
```
id -u docker
```
1. Avec un compte administrateur,

```
su cc-yross
sudo vim /etc/sysctl.conf
```
 y ajouter cette ligne:
```
net.ipv4.ip_unprivileged_port_start=80
```

Ensuite exécuter la commande `sudo sysctl --system`

Retourner sur le user docker avec la commande exit

1. Cloner ce répertoire: `git clone https://github.com/yvanross/docker-swarm-configs.git`

Generate Github personnal access token
https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token

1. Modifier `traefikv2/traefikv2.service` et `portainer/portainer.service` pour que les chemins des répertoires correspondent à votre configuration.
```
whereis docker-compose
cd docker-swarm-config/
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
systemctl --user start traefikv2.service
systemctl --user start portainer.service

# Si les variables d'environnement sont mis après avoir configurer les services
systemctl --user daemon-reload

# pour arrèter
systemctl --user stop portainer.service
```

8. Detacher de screen en conservant la session active: `ctrl a d`

9. Vous avez maintenant accès à traefik via `http://traefik.YOUR_DOMAIN.nip.io` et à portainer via `http://portainer.YOUR_DOMAIN.nip.io`


Voir [Portainer configuration](PORTAINER-CONFIG.MD)
Voir [Portainer docker file](PORTAINER.MD)

# pour débugger
journalctl -xe

pour traefik
Dans folder docker-swarm-configs/traefikv2, rouler:

DOMAIN=1.2.3.4.nip.io docker-compose up
Evidemment le domaine tu mets la vrai valeur, pas 1.2.3.4 