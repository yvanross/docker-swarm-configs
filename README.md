# Configuration docker-compose avec traefik et portainer


## Connection au serveur virtuel
ssh docker@YOUR_DOMAIN
Changer le mot de passe avec la commande
```
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
mkdir -p ~/.config/environment.d/10-docker.conf
vim ~/.config/environment.d/10-docker.conf
```
Ajouter le texte suivant
```
DOMAIN=YOUR_DOMAIN_HERE
DOCKER_HOST=unix:///run/user/YOUR_USER_UID_HERE/docker.sock
```
exemple:
```
DOMAIN=YOUR_DOMAIN.nip.io
DOCKER_HOST=unix:///run/user/1003/docker.sock
```

2. Avec un compte administrateur, `sudo vim /etc/systcl.conf` pour y ajouter cette ligne:

```
net.ipv4.ip_unprivileged_port_start=80
```

Ensuite exécuter la commande `sudo sysctl --system`

3. Cloner ce répertoire: `git clone git@github.com:yvanross/docker-swarm-config.git`
   ```
   cd LOG430-docker-swarm-config
   git checkout master

   ```

4. Modifier `traefikv2/traefikv2.service` et `portainer/portainer.service` pour que les chemins des répertoires correspondent à votre configuration.
```
whereis docker-compose
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
```

8. Detacher de screen en conservant la session active: `ctrl a d`

9. Vous avez maintenant accès à traefik via `http://traefik.YOUR_DOMAIN` et à portainer via `http://portainer.YOUR_DOMAIN`


Voir [Portainer configuration](PORTAINER-CONFIG.MD)
Voir [Portainer docker file](PORTAINER.MD)