MATCH (n:Event:Suspicious)--(p:Person) RETURN *

duration('P1W')

MATCH (n:Event:Suspicious)--(p:Person) RETURN *

WITH duration('P1W') as diff
MATCH (e0:Purchase:Suspicious)--(p1:Person)--(e1:Event)--(p2:Person)
WHERE e1.created_at > e0.created_at + diff
WITH collect(p2) as people2
MATCH (e2:Event)
WHERE ALL(p in people2 WHERE (p)--(e2))
RETURN *

WITH duration('P1W') as diff
MATCH (e0:Purchase:Suspicious)--(p1:Person)--(e1:Event)--(p2:Person)
WHERE e1.created_at < e0.created_at + diff
RETURN *

WITH duration('P1M') as diff
MATCH (e0:Purchase:Suspicious)--(p1:Person)--(e1:Event)--(p2:Person)--(e2:Event)--(p3:Person)
WHERE e1.created_at > e0.created_at + diff
AND   e2.created_at > e0.created_at + diff + diff
RETURN *

WITH duration('P1M') as diff
MATCH (e0:Purchase:Suspicious)--(p1:Person)--(e1:Event)--(p2:Person)--(e2:Event)--(p3:Person)
WHERE e1.created_at > e0.created_at + diff
AND   e2.created_at > e0.created_at + diff + diff
RETURN *

MATCH (e0:Purchase:Suspicious)--(p1:Person)--(e1:Event)--(p2:Person)
WITH e0, e1, apoc.coll.union(collect(p1),collect(p2)) as people12
MATCH (px:Person)
WHERE ANY(p in people12 WHERE (p)-[*..5]-(px))
RETURN *



MATCH (s:Suspicious:Event)--(x:Person)
WITH s,x
OPTIONAL MATCH (x)-[:SOURCE]->(p:Purchase)
RETURN s,x,p

MATCH (s:Suspicious:Event)--(x:Person)
RETURN *


MATCH (s:Suspicious:Purchase)--(x:Person)--(e:Event)--(y:Person) RETURN *


MATCH (x:Suspicious:Person)-[*..1]-(y:Suspicious:Person) RETURN *