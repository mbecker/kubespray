# Keycloak Themes

To enabled editing the themes the configuration for caching must be disabled and the server restarted.

1. Log into pod 'keycloak-0'
```shell
kubectl exec -it keycloak -- sh
```

2. Edit the following files:
```shell
grep -rnw keycloak/ -e 'cacheTemplates'
keycloak/standalone/configuration/standalone.xml:500:                <cacheTemplates>true</cacheTemplates>
keycloak/standalone/configuration/standalone-ha.xml:550:                <cacheTemplates>true</cacheTemplates>
keycloak/domain/configuration/domain.xml:431:                    <cacheTemplates>true</cacheTemplates>
keycloak/domain/configuration/domain.xml:933:                    <cacheTemplates>true</cacheTemplates>
```
Replace the following lines:
```shell
<staticMaxAge>2592000</staticMaxAge>
<cacheThemes>true</cacheThemes>
<cacheTemplates>true</cacheTemplates>
```
with the following lines:
```shell
<staticMaxAge>-1</staticMaxAge>
<cacheThemes>false</cacheThemes>
<cacheTemplates>false</cacheTemplates>
```

3. Restart server
```shell
./keycloak/bin/jboss-cli.sh --connect command=:reload
```


