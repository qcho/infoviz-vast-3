# Vast Mini-challenge 3

## Setting up

## Creating the database

The project requires postgres to be installed and globally available.

Run the following commands to initialize the database:

```bash
psql -f 01_create_user.sql
psql -f 02_create_data.sql
psql -f 03_create_metabase.sql
psql -f 04_migrate_suspicious.sql
psql -f 05_fix_created_at_column.sql
psql -f 06_views.sql
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

## Neo4j

To set up the Neo4j database, there are two different scripts that generate the two databases that were used for this project.

For the first one, you should run all of the queries inside the `setup/neo4j_data.cql` queries. This one contains only People nodes and each event is a relationship.

For the second one, run all of the queries in `setup/neo4j_allnodex.cql`. This one contains nodes for each type of event as well as for People.

Last one, `data/neo4j_aggregated_data.cql` contains only People nodes and each relationship contains the amount of times person _A_ communicated with person _B_, showing how the communication flowed in the organization.
