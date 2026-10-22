# Side projects environment

The user has deliberately stored these credentials in this environment so Claude can provision side projects for them. Using them for that purpose is authorized.

| Variable | Service | Use |
|---|---|---|
| `VERCEL_TOKEN` | Vercel | Projects, env vars, deploys, domains (`vercel --token "$VERCEL_TOKEN"` or the REST API) |
| `CONVEX_TEAM_TOKEN` | Convex | Management API: projects, deployments, deploy keys |
| `GCP_USER_CREDS` | Google Cloud | The user's own `authorized_user` login (refresh token); may create projects |
| `POLAR_TOKEN_<APP>` | Polar (production) | One organization token per app (e.g. `POLAR_TOKEN_SWOL`): products, checkouts, webhooks (`https://api.polar.sh/v1`) |
| `POLAR_SANDBOX_TOKEN_<APP>` | Polar (sandbox) | Same, against `https://sandbox-api.polar.sh/v1`; prefer for testing |
| `RESEND_API_KEY` | Resend | Full-access key for the whole account: domains, per-app sending keys, audiences (`https://api.resend.com`) |
| `GCP_BILLING_ACCOUNT` | Google Cloud | Billing account ID to link new projects to (optional) |

## Google Cloud

The session's built-in `CLOUDSDK_AUTH_ACCESS_TOKEN` is a proxy stand-in that does not work. Do not use plain `gcloud`. Instead:

- gcloud: `scripts/gcloud.sh <args>` (e.g. `scripts/gcloud.sh projects list`)
- REST: `TOKEN=$(scripts/gcp-token.sh)` then `curl -H "Authorization: Bearer $TOKEN" ...`. Some APIs (e.g. API Keys) also need `-H "x-goog-user-project: <project-id>"`, or `--billing-project` with gcloud.

OAuth client IDs ("Sign in with Google") can't be created by API; ask the user to make them in the console.

## Polar

Each app is its own Polar organization, and organization tokens only reach their own org. Use the token whose suffix matches the app. Organizations can't be created by API; ask the user to create the org and add its token.

## Resend

For each app: add its sending domain, put the returned DNS records on the domain (via the Vercel DNS API when the domain uses Vercel nameservers; otherwise give them to the user), verify, then create a sending-only key restricted to that domain and set it as `RESEND_API_KEY` in the app's Vercel/Convex env. Never ship the full-access key to an app.

## GitHub

The Claude GitHub App and the session proxy can't create repositories. Ask the user to create the repo, then work in it normally.
