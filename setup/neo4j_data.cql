// Create index
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM 'file:///data/CompanyIndex.csv' AS row
CREATE (:Person {ID: row.ID, name: (row.first + " " + row.last)});

USING PERIODIC COMMIT
LOAD CSV FROM 'file:////data/calls.csv' AS row
MATCH (source:Person {ID: row[0]})
MATCH (target:Person {ID: row[2]})
MERGE (source)-[c:CALLS]->(target)
ON CREATE SET c.created_at = datetime({epochSeconds: 1431352800 + toInteger(row[3])});
