// Script to generate nodes for both people and events and link them together

// Create People nodes
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM 'file:///data/CompanyIndex.csv' AS row
CREATE (:Person {
    ID: row.ID,
    name: (row.first + " " + row.last)
});

CREATE CONSTRAINT ON (p:Person) ASSERT p.ID IS UNIQUE;
CREATE INDEX ON :Person(name);

WITH [
    'Alex Hall', 'Lizbeth Jindra', 'Patrick Lane', 'Richard Fox', 'Sara Ballard', 'May Burton',
    'Glen Grant', 'Dylan Ballard', 'Meryl Pastuch', 'Melita Scarpaci', 'Augusta Sharp',
    'Kerstin Belveal', 'Rosalia Larroque', 'Lindsy Henion', 'Julie Tierno', 'Jose Ringwald',
    'Ramiro Gault', 'Tobi Gatlin', 'Refugio Orrantia', 'Jenice Savaria'
] AS suspects
MATCH(suspect:Person)
WHERE suspect.name IN suspects
SET suspect :Suspicious;

CREATE INDEX ON :Event(created_at);

USING PERIODIC COMMIT 10000
LOAD CSV FROM 'file:///data/calls.csv' AS row
MATCH (src:Person {ID: row[0]})
MERGE (src)-[:SOURCE]->(evnt:Event:Call {created_at:datetime({epochSeconds: 1431352800 + toInteger(row[3])})})
WITH evnt, row
MATCH (tgt:Person {ID: row[2]})
MERGE (evnt)-[:TARGET]->(tgt);

USING PERIODIC COMMIT 10000
LOAD CSV FROM 'file:///data/emails.csv' AS row
MATCH (src:Person {ID: row[0]})
MERGE (src)-[:SOURCE]->(evnt:Event:Email {created_at:datetime({epochSeconds: 1431352800 + toInteger(row[3])})})
WITH evnt, row
MATCH (tgt:Person {ID: row[2]})
MERGE (evnt)-[:TARGET]->(tgt);

USING PERIODIC COMMIT 10000
LOAD CSV FROM 'file:///data/meetings.csv' AS row
MATCH (src:Person {ID: row[0]})
MERGE (src)-[:SOURCE]->(evnt:Event:Meeting {created_at:datetime({epochSeconds: 1431352800 + toInteger(row[3])})})
WITH evnt, row
MATCH (tgt:Person {ID: row[2]})
MERGE (evnt)-[:TARGET]->(tgt);

USING PERIODIC COMMIT 10000
LOAD CSV FROM 'file:///data/purchases.csv' AS row
MATCH (src:Person {ID: row[0]})
MERGE (src)-[:SOURCE]->(evnt:Event:Purchase {created_at:datetime({epochSeconds: 1431352800 + toInteger(row[3])})})
WITH evnt, row
MATCH (tgt:Person {ID: row[2]})
MERGE (evnt)-[:TARGET]->(tgt);

// SUSPICIOUS

USING PERIODIC COMMIT 10000
LOAD CSV FROM 'file:///data/Suspicious_calls.csv' AS row
MATCH
    (:Person {ID: row[0]})-[:SOURCE]->
    (evnt:Event:Call {created_at:datetime({epochSeconds: 1431352800 + toInteger(row[3])})})
    -[:TARGET]->(:Person {ID: row[2]})
SET evnt:Suspicious;

USING PERIODIC COMMIT 10000
LOAD CSV FROM 'file:///data/Suspicious_emails.csv' AS row
MATCH
    (:Person {ID: row[0]})-[:SOURCE]->
    (evnt:Event:Email {created_at:datetime({epochSeconds: 1431352800 + toInteger(row[3])})})
    -[:TARGET]->(:Person {ID: row[2]})
SET evnt:Suspicious;

USING PERIODIC COMMIT 10000
LOAD CSV FROM 'file:///data/Suspicious_meetings.csv' AS row
MATCH
    (:Person {ID: row[0]})-[:SOURCE]->
    (evnt:Event:Meeting {created_at:datetime({epochSeconds: 1431352800 + toInteger(row[3])})})
    -[:TARGET]->(:Person {ID: row[2]})
SET evnt:Suspicious;

USING PERIODIC COMMIT 10000
LOAD CSV FROM 'file:///data/Suspicious_purchases_fixed.csv' AS row
MATCH
    (:Person {ID: row[0]})-[:SOURCE]->
    (evnt:Event:Purchase {created_at:datetime({epochSeconds: 1431352800 + toInteger(row[3])})})
    -[:TARGET]->(:Person {ID: row[2]})
SET evnt:Suspicious;


// PUNTO 4

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM 'file:///data/Other_suspicious_purchases.csv' AS row
MATCH
    (:Person {ID: row.Source})-[:SOURCE]->
    (evnt:Event:Purchase {created_at:datetime({epochSeconds: 1431352800 + toInteger(row.Time)})})
    -[:TARGET]->(:Person {ID: row.Dest})
SET evnt:OtherSuspicious;
