\c vast3 infoviz;

-- All employee records together
CREATE VIEW all_records AS
    SELECT * FROM calls UNION
    SELECT * FROM purchases UNION
    SELECT * FROM emails UNION
    SELECT * FROM meetings
;

-- Employer creation
CREATE MATERIALIZED VIEW employee_activity_range AS
    SELECT DISTINCT
        employer_id, min(created_at) as begin_date, max(created_at) as end_date
    FROM company_index
    JOIN all_records ON employer_id = all_records.source_id OR employer_id = all_records.target_id
    GROUP BY employer_id
;

-- Communication count between employees (A->B and B->A are in SEPARATE rows)
CREATE MATERIALIZED VIEW employee_communication_split AS
    SELECT source_id, target_id, etype_id, COUNT(1) as total
    FROM all_records
    GROUP BY source_id, target_id, etype_id
;

-- Communication count between employees per week (A->B and B->A are in SEPARATE rows)
CREATE MATERIALIZED VIEW employee_communication_by_week_split AS
    SELECT
        source_id,
        target_id,
        etype_id,
        (date_trunc('week', CAST((created_at + INTERVAL '1 day') AS timestamp)) - INTERVAL '1 day') AS created_at_week,
        COUNT(*) as total
    FROM
        all_records
    GROUP BY
        source_id, target_id, etype_id, created_at_week
;



--     WHERE  d1.source_id IN (SELECT employer_id FROM company_index WHERE suspicious = true)
--     AND d1.target_id IN (SELECT employer_id FROM company_index WHERE suspicious = true)