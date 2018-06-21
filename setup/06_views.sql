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

-- Communication count between employees per week (A->B and B->A are MERGED)
CREATE MATERIALIZED VIEW employee_communication_by_week AS
    SELECT s as source_id, t as target_id, w as week, e as e_type, SUM(tt) as total FROM
        (
            SELECT source_id as s, target_id as t, etype_id as e, created_at_week as w, total FROM employee_communication_by_week_split WHERE source_id < target_id
            UNION
            SELECT target_id as s, source_id as t, etype_id as e, created_at_week as w, total FROM employee_communication_by_week_split WHERE source_id >= target_id
        ) as tmp(s, t, e, w, tt)
    GROUP BY s, t, e, w
;

-- All suspicious records together
CREATE MATERIALIZED VIEW all_suspicious_records AS
    SELECT a.* FROM all_records AS a
    JOIN company_index AS s ON s.employer_id = source_id
    JOIN company_index AS t ON t.employer_id = target_id
    WHERE a.suspicious = true OR s.suspicious = true OR t.suspicious = true
;

-- Communication count between employees per week (A->B and B->A are in SEPARATE rows)
CREATE MATERIALIZED VIEW communication_overview_split AS
    SELECT
        source_id,
        target_id,
        date_trunc('week', created_at) AS created_at_week,
        SUM((etype_id = 0 AND NOT suspicious)::int) as calls,
        SUM((etype_id = 1 AND NOT suspicious)::int) as emails,
        SUM((etype_id = 3 AND NOT suspicious)::int) as meetings,
        SUM((etype_id = 2 AND NOT suspicious)::int) as purchases,
        SUM((etype_id = 0 AND     suspicious)::int) as suspicious_calls,
        SUM((etype_id = 1 AND     suspicious)::int) as suspicious_emails,
        SUM((etype_id = 3 AND     suspicious)::int) as suspicious_meetings,
        SUM((etype_id = 2 AND     suspicious)::int) as suspicious_purchases,
        COUNT(*) AS total
    FROM
        all_records
    GROUP BY
        source_id, target_id, created_at_week
;

-- Communication count between employees per week (A->B and B->A are in SEPARATE rows)
CREATE MATERIALIZED VIEW communication_overview_suspicious_split AS
    SELECT
        source_id,
        target_id,
        date_trunc('week', created_at) AS created_at_week,
        SUM((etype_id = 0 AND NOT suspicious)::int) as calls,
        SUM((etype_id = 1 AND NOT suspicious)::int) as emails,
        SUM((etype_id = 3 AND NOT suspicious)::int) as meetings,
        SUM((etype_id = 2 AND NOT suspicious)::int) as purchases,
        SUM((etype_id = 0 AND     suspicious)::int) as suspicious_calls,
        SUM((etype_id = 1 AND     suspicious)::int) as suspicious_emails,
        SUM((etype_id = 3 AND     suspicious)::int) as suspicious_meetings,
        SUM((etype_id = 2 AND     suspicious)::int) as suspicious_purchases,
        COUNT(*) AS total
    FROM
        all_suspicious_records
    GROUP BY
        source_id, target_id, created_at_week
;

-- Active employees per month
CREATE MATERIALIZED VIEW active_people_per_month AS
WITH date_series AS (
    SELECT generate_series(
        date_trunc('month', min(begin_date)),
        date_trunc('month', max(end_date)),
        '1 month') as month
    FROM employee_activity_range
)
SELECT
    month,
    SUM((
        (date_trunc('month', begin_date), date_trunc('month', end_date) + interval '1 month') OVERLAPS (month, INTERVAL '1 month')
    )::int) as active_users
FROM
    date_series,
    employee_activity_range
GROUP BY month
ORDER BY month ASC
;

-- Leaving employees per month
CREATE MATERIALIZED VIEW leaving_people_per_month AS
WITH date_series AS (
    SELECT generate_series(
        date_trunc('month', min(begin_date)),
        date_trunc('month', max(end_date)),
        '1 month') as month
    FROM employee_activity_range
)
SELECT
    month,
    SUM((
        (date_trunc('month', end_date), INTERVAL '1 day') OVERLAPS (month - interval '1 month', interval '1 month')
    )::int) as active_users
FROM
    date_series,
    employee_activity_range
GROUP BY month
;
