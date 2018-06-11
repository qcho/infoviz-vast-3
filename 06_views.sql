\c vast3 infoviz;

-- All employee records together
CREATE VIEW all_records AS
    SELECT * FROM calls UNION
    SELECT * FROM purchases UNION
    SELECT * FROM emails UNION
    SELECT * FROM meetings
;

-- Employer creation
CREATE MATERIALIZED VIEW employee_first_activity AS
    SELECT DISTINCT
        employer_id, min(created_at) as created_at
    FROM company_index
    JOIN all_records ON employer_id = all_records.source_id OR employer_id = all_records.target_id
    GROUP BY employer_id
;