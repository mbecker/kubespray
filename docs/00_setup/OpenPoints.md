# Open Points

## Elastcisearch / Kibana
Docker Registry: https://www.docker.elastic.co/#

### Security / RBAC / Authorization
X-Pack is enabled in Docker version starting v6.3. See paage: https://www.elastic.co/de/products/x-pack/open
The configuration is described at: https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-security.html
The *Configration Transport Layer Security (TLS/SSL) for internode-communication* is required to enable X-Pack-Security features. To enable secure communication certificates must be generated for all nodes in cluster.
