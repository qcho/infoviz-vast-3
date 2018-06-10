DROP DATABASE IF EXISTS vast3;
DROP DATABASE IF EXISTS metabase;
DROP USER IF EXISTS infoviz;

CREATE USER infoviz WITH PASSWORD 'infoviz' CREATEDB;
CREATE DATABASE vast3 OWNER infoviz;
CREATE DATABASE metabase OWNER infoviz;

\c vast3 infoviz;

CREATE TABLE company_index (
    name VARCHAR,
    surname VARCHAR,
    employer_id integer NOT NULL PRIMARY KEY
);

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
    created_at bigint NOT NULL
);

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
    created_at bigint NOT NULL
);

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
    created_at bigint NOT NULL
);

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
    created_at bigint NOT NULL
);

CREATE TABLE suspicious_meetings (
    source_id int NOT NULL REFERENCES company_index(employer_id),
    etype_id int NOT NULL REFERENCES etype(id),
    target_id int NOT NULL REFERENCES company_index(employer_id),
    created_at bigint NOT NULL
);

\COPY company_index FROM 'data/CompanyIndex.csv' CSV HEADER;
\COPY calls FROM 'data/calls.csv' CSV;
\COPY suspicious_calls FROM 'data/Suspicious_calls.csv' CSV;
\COPY emails FROM 'data/emails.csv' CSV;
\COPY suspicious_emails FROM 'data/Suspicious_emails.csv' CSV;
\COPY meetings FROM 'data/meetings.csv' CSV;
\COPY suspicious_meetings FROM 'data/Suspicious_meetings.csv' CSV;
\COPY purchases FROM 'data/purchases.csv' CSV;
\COPY suspicious_purchases FROM 'data/Suspicious_purchases.csv' CSV;
\COPY other_suspicious_purchases FROM 'data/Other_suspicious_purchases.csv' CSV HEADER;

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
