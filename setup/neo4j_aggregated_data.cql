// This file uses aggregated information generated from Postgres to see only how many times people communicated with each other
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM 'file:///data/CompanyIndex.csv' AS row
CREATE (:Person {ID: row.ID, name: (row.first + " " + row.last)});

CREATE INDEX ON :Person(ID);

USING PERIODIC COMMIT
LOAD CSV FROM 'file:///aggregated_interactions.csv' AS row
MATCH (source:Person {ID: row[0]})
MATCH (target:Person {ID: row[1]})
MERGE (source)-[c:INTERACTIONS]->(target)
ON CREATE SET c.count = toInteger(row[2]);

MATCH(suspect:Person)
WHERE suspect.name IN [
    'Alex Hall', 'Lizbeth Jindra', 'Patrick Lane', 'Richard Fox', 'Sara Ballard', 'May Burton',
    'Glen Grant', 'Dylan Ballard', 'Meryl Pastuch', 'Melita Scarpaci', 'Augusta Sharp',
    'Kerstin Belveal', 'Rosalia Larroque', 'Lindsy Henion', 'Julie Tierno', 'Jose Ringwald',
    'Ramiro Gault', 'Tobi Gatlin', 'Refugio Orrantia', 'Jenice Savaria'
]
SET suspect.suspicious = true;


// These are some queries which are useful for tagging Interactions between people,
// trying to identify communities and closeness
CALL algo.pageRank('Person', 'INTERACTIONS', {write: true, writeProperty: 'pagerank'});
CALL algo.labelPropagation('Person', 'INTERACTIONS', 'OUTGOING', {write: true, weightProperty: 'count', partitionProperty: 'community', iterations: 50})
CALL algo.louvain('Person', 'INTERACTIONS', {write: true, writeProperty: 'community'});