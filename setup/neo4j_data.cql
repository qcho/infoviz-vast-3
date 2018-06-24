// ---------------- Build database ----------------
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM 'file:///data/CompanyIndex.csv' AS row
CREATE (:Person {ID: row.ID, name: (row.first + " " + row.last)});

CREATE INDEX ON :Person(ID);

USING PERIODIC COMMIT
LOAD CSV FROM 'file:///data/calls.csv' AS row
MATCH (source:Person {ID: row[0]})
MATCH (target:Person {ID: row[2]})
MERGE (source)-[c:CALLS]->(target)
ON CREATE SET c.created_at = datetime({epochSeconds: 1431352800 + toInteger(row[3])});

USING PERIODIC COMMIT
LOAD CSV FROM 'file:///data/emails.csv' AS row
MATCH (source:Person {ID: row[0]})
MATCH (target:Person {ID: row[2]})
MERGE (source)-[c:EMAILS]->(target)
ON CREATE SET c.created_at = datetime({epochSeconds: 1431352800 + toInteger(row[3])});

USING PERIODIC COMMIT
LOAD CSV FROM 'file:///data/meetings.csv' AS row
MATCH (source:Person {ID: row[0]})
MATCH (target:Person {ID: row[2]})
MERGE (source)-[c:MEETS]->(target)
ON CREATE SET c.created_at = datetime({epochSeconds: 1431352800 + toInteger(row[3])});

USING PERIODIC COMMIT
LOAD CSV FROM 'file:///data/purchases.csv' AS row
MATCH (source:Person {ID: row[0]})
MATCH (target:Person {ID: row[2]})
MERGE (source)-[c:PURCHASES_FROM]->(target)
ON CREATE SET c.created_at = datetime({epochSeconds: 1431352800 + toInteger(row[3])});

WITH [
    'Alex Hall', 'Lizbeth Jindra', 'Patrick Lane', 'Richard Fox', 'Sara Ballard', 'May Burton',
    'Glen Grant', 'Dylan Ballard', 'Meryl Pastuch', 'Melita Scarpaci', 'Augusta Sharp',
    'Kerstin Belveal', 'Rosalia Larroque', 'Lindsy Henion', 'Julie Tierno', 'Jose Ringwald',
    'Ramiro Gault', 'Tobi Gatlin', 'Refugio Orrantia', 'Jenice Savaria'
] as suspects
MATCH(suspect:Person)
WHERE suspect.name IN suspects
SET suspect :Suspect
RETURN suspect;

USING PERIODIC COMMIT
LOAD CSV FROM 'file:///data/purchases.csv' AS row
MATCH (source:Person {ID: row[0]})
MATCH (target:Person {ID: row[2]})
MERGE (source)-[c:PURCHASES_FROM]->(target)
ON CREATE SET c.created_at = datetime({epochSeconds: 1431352800 + toInteger(row[3])});

LOAD CSV FROM 'file:////data/suspicious_calls.csv' AS row
MATCH (source:Person {ID: row[0]})-[c]-(target:Person {ID: row[2]})
RETURN source,c,target;

LOAD CSV FROM 'file:////data/Other_suspicious_purchases.csv' AS row
MATCH (source {ID: row[0]})-[c]-(target {ID: row[2]})
WHERE c.created_at = datetime({epochSeconds: 1431352800 + toInteger(row[3])})
RETURN source,c,target;

LOAD CSV FROM 'file:////data/Suspicious_purchases.csv' AS row
MATCH (source {ID: row[0]})-[c]-(target {ID: row[2]})
RETURN source,c,target;


// Personas que han tenido relación con al menos dos sospechosos.
MATCH (s1:Suspect)--(p:Person)--(s2:Suspect)
WHERE NOT s1 = s2
return s1,p,s2

// Personas que han tenido relación con al menos dos sospechosos.
MATCH (s1:Suspect)<--(p:Person)-->(s2:Suspect)
WHERE NOT s1 = s2
return s1,p,s2

// Personas que han tenido relación con al menos dos sospechosos.
MATCH (s1:Suspect)-->(p:Person)<--(s2:Suspect)
WHERE NOT s1 = s2
return s1,p,s2
