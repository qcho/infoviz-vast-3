-- This file contains a series of queries useful for visualization elsewhere

COPY (SELECT source_id, target_id, SUM(total) as interactions FROM employee_communication_split GROUP BY source_id, target_id) TO '/tmp/aggregated_interactions.csv' WITH CSV DELIMITER ',';