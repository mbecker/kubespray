# Grafan OAuth 2.0

## Configuration 
```json
{
  "name": "GF_AUTH_GENERIC_OAUTH_ENABLED",
  "value": "false"
},
{
  "name": "GF_AUTH_GENERIC_OAUTH_CLIENT_ID",
  "value": "kubernetes"
},
{
  "name": "GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET",
  "value": "4d0462da-5ab3-4665-8b05-9e2ff3f1b448"
},
{
  "name": "GF_AUTH_GENERIC_OAUTH_SCOPES",
  "value": "openid profile email"
},
{
  "name": "GF_AUTH_GENERIC_OAUTH_AUTH_URL",
  "value": "https://keycloak.mobility.digital/auth/realms/hello/protocol/openid-connect/auth"
},
{
  "name": "GF_AUTH_GENERIC_OAUTH_TOKEN_URL",
  "value": "https://keycloak.mobility.digital/auth/realms/hello/protocol/openid-connect/token"
},
{
  "name": "GF_AUTH_GENERIC_OAUTH_API_URL",
  "value": "https://keycloak.mobility.digital/auth/realms/hello/protocol/openid-connect/userinfo"
},
{
  "name": "GF_AUTH_GENERIC_OAUTH_ALLOWED_DOMAINS",
  "value": "mobility.digital grafana.mobility.digital keycloak.mobility.digital"
},
{
  "name": "GF_AUTH_GENERIC_OAUTH_ALLOW_SIGN_UP",
  "value": "true"
}
```              
