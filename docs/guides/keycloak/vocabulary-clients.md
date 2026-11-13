# Keycloak Clients for the Vocabulary Realm

The `Vocabulary` realm configuration exists only in Keycloak. It is not exported to this repository. This guide records the clients the applications depend on, so that they can be checked or recreated if the realm is rebuilt.

No secrets are recorded here. `vocabulary-app` and `vocabulary-mobile` are public clients and have no secret.

## Clients

| Client | Type | Used by |
|---|---|---|
| `vocabulary-app` | Public, standard flow, PKCE S256 | Web frontend (`my-vocabulary`) |
| `vocabulary-mobile` | Public, standard flow, PKCE S256 | Android app (`vocabulary-mobile`) |
| `vocabulary-api-admin` | Confidential | API token introspection (`vocabulary-api`) |

## Audience Mapper (Required)

The API validates tokens through Keycloak introspection, authenticated as `vocabulary-api-admin`. Keycloak only accepts the introspection when `vocabulary-api-admin` is in the token audience. Otherwise it logs `INTROSPECT_TOKEN_ERROR` ("Client 'vocabulary-api-admin' is not in the token audience"), and the API returns HTTP 401.

Every public client that calls the API therefore has a dedicated mapper:

| Setting | Value |
|---|---|
| Name | `aud-vocabulary-api-admin` |
| Mapper type | Audience (`oidc-audience-mapper`) |
| Included Client Audience | `vocabulary-api-admin` |
| Included Custom Audience | empty |
| Add to access token | ON |
| Add to token introspection | ON |
| Add to ID token, userinfo, lightweight | OFF |

In the console: Clients → `<client>` → Client scopes → `<client>-dedicated` → Mappers.

Check the result in Client scopes → Evaluate → Generated access token: `aud` must contain `vocabulary-api-admin`, with no trailing space. `account` is also present by default.

## vocabulary-app

| Setting | Value |
|---|---|
| Standard flow | ON |
| Implicit flow, direct access grants, service accounts | OFF |
| PKCE method | S256 |
| Redirect URIs | `https://vocabulary.nst.art.br/*`, `http://localhost:8081/*` |
| Web origins | `https://vocabulary.nst.art.br`, `http://localhost:8081` |
| Post logout redirect URIs | `https://vocabulary.nst.art.br/*`, `http://localhost:8081/*` |
| Mappers | `aud-vocabulary-api-admin` |

## vocabulary-mobile

Created on 2026-11-13 (cloud-native-lab#11). It is separate from `vocabulary-app` so that web and mobile redirect URIs are not mixed.

| Setting | Value |
|---|---|
| Name | Vocabulary Mobile |
| Standard flow | ON |
| Implicit flow, direct access grants, service accounts | OFF |
| PKCE method | S256 |
| Redirect URIs | `com.alexsandro.vocabulary://oauth/callback` |
| Web origins | none |
| Post logout redirect URIs | `+` (same as the redirect URIs) |
| Mappers | `aud-vocabulary-api-admin` |

The redirect URI uses the Android package name as the custom scheme. It must match `scheme` in the mobile `app.json`.

## Managing Clients with kcadm.sh

The administrator password is not the bootstrap value stored in the Keycloak Secret. Log in interactively, so that the password is typed only into the terminal:

```bash
kubectl-aws -n identity exec -it deploy/keycloak -- \
  /opt/keycloak/bin/kcadm.sh config credentials \
  --server http://localhost:8080 --realm master --user admin
```

The session is stored inside the pod in `~/.keycloak/kcadm.config`. Remove it when finished:

```bash
kubectl-aws -n identity exec deploy/keycloak -- rm -f /opt/keycloak/.keycloak/kcadm.config
```

### Recreate vocabulary-mobile

Run inside the pod (`kubectl-aws -n identity exec -it deploy/keycloak -- sh`), with `K=/opt/keycloak/bin/kcadm.sh`:

```bash
ID=$($K create clients -r Vocabulary -i \
  -s clientId=vocabulary-mobile -s name="Vocabulary Mobile" -s enabled=true \
  -s protocol=openid-connect -s publicClient=true \
  -s standardFlowEnabled=true -s implicitFlowEnabled=false \
  -s directAccessGrantsEnabled=false -s serviceAccountsEnabled=false \
  -s 'redirectUris=["com.alexsandro.vocabulary://oauth/callback"]' \
  -s 'webOrigins=[]' \
  -s 'attributes."pkce.code.challenge.method"=S256' \
  -s 'attributes."post.logout.redirect.uris"=+')

$K create clients/$ID/protocol-mappers/models -r Vocabulary \
  -s name=aud-vocabulary-api-admin -s protocol=openid-connect \
  -s protocolMapper=oidc-audience-mapper \
  -s 'config."included.client.audience"=vocabulary-api-admin' \
  -s 'config."access.token.claim"=true' \
  -s 'config."introspection.token.claim"=true' \
  -s 'config."id.token.claim"=false' \
  -s 'config."lightweight.claim"=false' \
  -s 'config."userinfo.token.claim"=false'
```

### Verify

```bash
ID=$($K get clients -r Vocabulary -q clientId=vocabulary-mobile --fields id --format csv --noquotes)
USER_ID=$($K get users -r Vocabulary --limit 1 --fields id --format csv --noquotes)
$K get clients/$ID/evaluate-scopes/generate-example-access-token -r Vocabulary \
  -q scope=openid -q userId=$USER_ID
```

Check `azp` (`vocabulary-mobile`) and `aud` (contains `vocabulary-api-admin`) in the output. Do not paste the generated token into issues or chat.
