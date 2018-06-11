# Vast Mini-challenge 3

## Setting up

## Creating the database

The project requires postgres to be installed and globally available.

Run the following commands to initialize the database:

```bash
psql -f 01_create_user.sql
psql -f 02_create_data.sql
psql -f 03_create_metabase.sql
```

## Metabase

### Installation

Docker is required to run Metabase, so install it from the [Docker official website](https://store.docker.com/search?type=edition&offering=community).

Once installed, run the following command from the root directory of this project:

```bash
docker-compose up
```

Once that finishes, the project should be available.

### Setup

When configuring the datasource, set the following:

- Name: vast3
- Host: host.docker.internal
- Port: 5432
- User: infoviz
- Password: infoviz
- Database: vast3
