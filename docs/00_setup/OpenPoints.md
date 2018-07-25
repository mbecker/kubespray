# Open Points

## Kubernetes API Server

## Loadbalancer

> Should the API Server be installed behind a proxy?

## Elastcisearch / Kibana
Docker Registry: https://www.docker.elastic.co/#

### Security / RBAC / Authorization
X-Pack is enabled in Docker version starting v6.3. See paage: https://www.elastic.co/de/products/x-pack/open
The configuration is described at: https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-security.html
The *Configration Transport Layer Security (TLS/SSL) for internode-communication* is required to enable X-Pack-Security features. To enable secure communication certificates must be generated for all nodes in cluster.

> Workaround
> Use proxy in front of Kibana. No RBAC authorization; just simple basic OAuth 2.0 AuthN/AutHz with Keycloak.
> [Kibana / Keycloak](https://aboullaite.me/secure-kibana-keycloak/)
> ![AuthN / AuthZ Architecture for Kibana](https://aboullaite.me/content/images/2018/02/Presentation1.jpg)
