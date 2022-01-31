
### Configurations du routage des services

Le format suivant décrit le format `docker-compose` à respecter par un service pou avoir du routage. Toutes les valeurs en majuscules sont à personnalise.

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

