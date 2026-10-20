# Architecture Diagram — GCP Cloud Run + Cloud SQL

## Lucid diagram

- **View:** https://lucid.app/lucidchart/90f00d10-7bb8-4b98-8cbe-0bb6212540bb/view
- **Edit:** https://lucid.app/lucidchart/90f00d10-7bb8-4b98-8cbe-0bb6212540bb/edit

## Lucid prompt (reusable)

```
Create a GCP architecture diagram titled "GCP Cloud Run + Cloud SQL".
A User connects over HTTPS to a Cloud Run service, which connects to a Cloud SQL
(PostgreSQL) database using the instance connection. Label the arrows. Clean,
professional Google Cloud colors.
```

## Mermaid source

```mermaid
flowchart LR
    User([User])
    CR[Cloud Run Service]
    SQL[(Cloud SQL - PostgreSQL)]
    User -->|HTTPS| CR
    CR -->|SQL connection| SQL
```
