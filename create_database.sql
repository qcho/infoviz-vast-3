DROP DATABASE IF EXISTS vast3;
DROP USER IF EXISTS infoviz;

CREATE USER infoviz WITH PASSWORD 'infoviz' CREATEDB;
CREATE DATABASE vast3 OWNER infoviz;

\c vas3 infoviz;

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
\COPY other_suspicious_purchases FROM 'data/Other_suspicious_purchases.csv' CSV;
