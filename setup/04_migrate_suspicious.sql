-- Migrate suspicions

\c vast3 infoviz;

-- Flag suspected employees
UPDATE company_index SET suspicious = true WHERE concat_ws(' ', name, surname) IN (
    'Alex Hall', 'Lizbeth Jindra', 'Patrick Lane', 'Richard Fox', 'Sara Ballard', 'May Burton',
    'Glen Grant', 'Dylan Ballard', 'Meryl Pastuch', 'Melita Scarpaci', 'Augusta Sharp',
    'Kerstin Belveal', 'Rosalia Larroque', 'Lindsy Henion', 'Julie Tierno', 'Jose Ringwald',
    'Ramiro Gault', 'Tobi Gatlin', 'Refugio Orrantia', 'Jenice Savaria'
);

-- Calls
UPDATE calls o SET suspicious = true
FROM suspicious_calls s
	WHERE o.source_id = s.source_id
	AND o.etype_id = s.etype_id
	AND o.target_id = s.target_id
	AND o.created_at = s.created_at;

DROP TABLE suspicious_calls;

-- Purchases
-- We commented out the created_at condition since there's only 1 suspicious purchase that matches both in
-- source and target but doesn't match the date (it is a very close match)
UPDATE purchases o SET suspicious = true
FROM suspicious_purchases s
	WHERE o.source_id = s.source_id
	AND o.etype_id = s.etype_id
	AND o.target_id = s.target_id
	-- AND o.created_at = s.created_at;

DROP TABLE suspicious_purchases;

-- Emails

UPDATE emails o SET suspicious = true
FROM suspicious_emails s
	WHERE o.source_id = s.source_id
	AND o.etype_id = s.etype_id
	AND o.target_id = s.target_id
	AND o.created_at = s.created_at;

DROP TABLE suspicious_emails;

-- Meetings

UPDATE meetings o SET suspicious = true
FROM suspicious_meetings s
	WHERE o.source_id = s.source_id
	AND o.etype_id = s.etype_id
	AND o.target_id = s.target_id
	AND o.created_at = s.created_at;

DROP TABLE suspicious_meetings;
