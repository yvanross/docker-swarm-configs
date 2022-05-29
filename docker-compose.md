
### Configurations du routage des services

Le format suivant décrit le format `docker-compose` à respecter par un service pour avoir du routage. Toutes les valeurs en majuscules sont à personnalise.


```yaml
version: '3.2'

services:
  app:
    image: VOTREIMAGE
    init: true
    ports:
      - PORT_HTTP
    networks:
      - internal_NOEQUIPE_NOMSERVICE
      - traefik_public
    labels:
      # traefik
      - traefik.enable=true
      - traefik.docker.network=traefik_public
      # traefikv2
      - "traefik.http.routers.NOEQUIPE_NOMSERVICE.rule=Host(`NOMSERVICE.NOEQUIPE.HOST_DOMAIN`)"
      - "traefik.http.routers.NOEQUIPE_NOMSERVICE.entrypoints=http"
      - "traefik.http.services.NOEQUIPE_NOMSERVICE.loadbalancer.server.port=PORT_HTTP"

networks:
  traefik_public:
    external: true
  internal_NOEQUIPE_NOMSERVICE:
```

Le tableau ci-dessous décrit les détails de ce qui peut être configuré

|Texte à modifier|Description|Restrictions |
|----|----|----|
|`VOTREIMAGE`|Nom de l'image à utiliser. | Le registry doit être publique ou enregistré dans l'Engine docker de l'hôte|
|`PORT_HTTP`| Port HTTP du conteneur| |
|`NOEQUIPE`| Numéro d'équipe dans le format `eqX` |  |
|`NOMSERVICE`| Nom du service | **Unique pour l'équipe** |
|`HOST_DOMAIN` | Domaine de l'hôte | Doit pointer vers la machine contenant le Docker Host |


## Pour tester le déploiement sur la machine virtuelle

http://HOST_DOMAIN.nip.io:3000/


 tu peux éviter de passer par les ports en n'exposant pas de ports publics (donc un port serait décrit par - 3000 plutôt que - 3001:3000), et ensuite tu peux utiliser traefik pour faire le routage par le host de cette facon: serviceName.10.194.33.153.nip.io (direct sur le port 80).  Voir la section label du docker-compose précédent.
 
 Le service devrait être disponible à:
 http://service_discovery.eq4.HOST_NAME.nip.io


Pour un service programmé dans le cadre du projet, qui utilisait l'API de docker, des fonctionnalités de cgroupv2 étaient nécessaires pour fonctionner en rootless. C'est extrêmement simple à changer (ajouter systemd.unified_cgroup_hierarchy=1 à GRUB_CMDLINE_LINUX dans GRUB )
