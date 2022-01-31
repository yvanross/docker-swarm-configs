# Configuration docker-compose avec traefik et portainer

## Prérequis

- Docker installé en *rootless*

## Étapes

1. Configurer les variables d'environnement (`~/.config/environment.d/10-docker.conf`):

```
DOMAIN=YOUR_DOMAIN_HERE
DOCKER_HOST=unix:///run/user/YOUR_USER_UID_HERE/docker.sock
```

2. Avec un compte administrateur, modifier `/etc/systcl.conf` pour y ajouter cette ligne:

```
net.ipv4.ip_unprivileged_port_start=80
```
Ensuite exécuter la commande `sudo sysctl --system`

3. Cloner ce répertoire: `git clone https://gitea.codegameeat.com:9443/simon/docker-swarm-configs.git`

3. Modifier `traefikv2/traefikv2.service` et `portainer/portainer.service` pour que les chemins des répertoires correspondent à votre configuration.

4. Créer des symlinks pour créer les services: 
```bash
ln -s ~/chemin/vers/repo/portainer/traefikv2.service ~/.config/systemd/user/traefikv2.service
ln -s ~/chemin/vers/repo/portainer/portainer.service ~/.config/systemd/user/portainer.service
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