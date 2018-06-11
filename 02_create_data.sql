DROP DATABASE IF EXISTS vast3;

CREATE DATABASE vast3 OWNER infoviz;

\c vast3 infoviz;

CREATE TABLE company_index (
    name VARCHAR,
    surname VARCHAR,
    employer_id integer NOT NULL PRIMARY KEY,
    suspicious boolean NOT NULL DEFAULT false
);

CREATE INDEX ON company_index(suspicious);

CREATE TABLE etype (
    id int PRIMARY KEY,
    type VARCHAR(20)
);

INSERT INTO etype (id, type) VALUES 
    (0, 'call'),
    (1, 'email'),
    (2, 'purchases'),
    (3, 'meetings')
;

CREATE TABLE calls (
    source_id int NOT NULL REFERENCES company_index(employer_id),
    etype_id int NOT NULL REFERENCES etype(id),
    target_id int NOT NULL REFERENCES company_index(employer_id),
    suspicious boolean NOT NULL DEFAULT false,
    created_at bigint NOT NULL
);

CREATE INDEX ON calls(suspicious);

CREATE TABLE suspicious_calls (
    source_id int NOT NULL REFERENCES company_index(employer_id),
    etype_id int NOT NULL REFERENCES etype(id),
    target_id int NOT NULL REFERENCES company_index(employer_id),
    created_at bigint NOT NULL
);

CREATE TABLE purchases (
    source_id int NOT NULL REFERENCES company_index(employer_id),
    etype_id int NOT NULL REFERENCES etype(id),
    target_id int NOT NULL REFERENCES company_index(employer_id),
    suspicious boolean NOT NULL DEFAULT false,
    created_at bigint NOT NULL
);

CREATE INDEX ON purchases(suspicious);

CREATE TABLE suspicious_purchases (
    source_id int NOT NULL REFERENCES company_index(employer_id),
    etype_id int NOT NULL REFERENCES etype(id),
    target_id int NOT NULL REFERENCES company_index(employer_id),
    created_at bigint NOT NULL
);

CREATE TABLE other_suspicious_purchases (
    source_id int NOT NULL REFERENCES company_index(employer_id),
    etype_id int NOT NULL REFERENCES etype(id),
    target_id int NOT NULL REFERENCES company_index(employer_id),
    created_at bigint NOT NULL
);

CREATE TABLE emails (
    source_id int NOT NULL REFERENCES company_index(employer_id),
    etype_id int NOT NULL REFERENCES etype(id),
    target_id int NOT NULL REFERENCES company_index(employer_id),
    suspicious boolean NOT NULL DEFAULT false,
    created_at bigint NOT NULL
);

CREATE INDEX ON emails(suspicious);

CREATE TABLE suspicious_emails (
    source_id int NOT NULL REFERENCES company_index(employer_id),
    etype_id int NOT NULL REFERENCES etype(id),
    target_id int NOT NULL REFERENCES company_index(employer_id),
    created_at bigint NOT NULL
);

CREATE TABLE meetings (
    source_id int NOT NULL REFERENCES company_index(employer_id),
    etype_id int NOT NULL REFERENCES etype(id),
    target_id int NOT NULL REFERENCES company_index(employer_id),
    suspicious boolean NOT NULL DEFAULT false,
    created_at bigint NOT NULL
);

CREATE INDEX ON meetings(suspicious);

CREATE TABLE suspicious_meetings (
    source_id int NOT NULL REFERENCES company_index(employer_id),
    etype_id int NOT NULL REFERENCES etype(id),
    target_id int NOT NULL REFERENCES company_index(employer_id),
    created_at bigint NOT NULL
);

\COPY company_index(name, surname, employer_id) FROM 'data/CompanyIndex.csv' CSV HEADER;
\COPY calls(source_id, etype_id, target_id, created_at) FROM 'data/calls.csv' CSV;
\COPY suspicious_calls FROM 'data/Suspicious_calls.csv' CSV;
\COPY emails(source_id, etype_id, target_id, created_at) FROM 'data/emails.csv' CSV;
\COPY suspicious_emails FROM 'data/Suspicious_emails.csv' CSV;
\COPY meetings(source_id, etype_id, target_id, created_at) FROM 'data/meetings.csv' CSV;
\COPY suspicious_meetings FROM 'data/Suspicious_meetings.csv' CSV;
\COPY purchases(source_id, etype_id, target_id, created_at) FROM 'data/purchases.csv' CSV;
\COPY suspicious_purchases FROM 'data/Suspicious_purchases.csv' CSV;
\COPY other_suspicious_purchases FROM 'data/Other_suspicious_purchases.csv' CSV HEADER;

-- Convert BigInteger to timestamp
-- Magic 1431352800 from:
-- SELECT extract(epoch from ('May 11, 2015 at 14:00 UTC' at time zone 'utc'));

ALTER TABLE calls
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

ALTER TABLE suspicious_calls
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

ALTER TABLE purchases
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

ALTER TABLE suspicious_purchases
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

ALTER TABLE other_suspicious_purchases
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

ALTER TABLE emails
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

ALTER TABLE meetings
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

ALTER TABLE suspicious_meetings
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

-- Migrate suspicions

ALTER TABLE calls
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

DROP TABLE suspicious_calls;

ALTER TABLE purchases
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

DROP TABLE suspicious_purchases;

ALTER TABLE other_suspicious_purchases
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

DROP TABLE emails
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

ALTER TABLE meetings
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

ALTER TABLE suspicious_meetings
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);
