-- Calls
ALTER TABLE calls
    ADD COLUMN suspicious boolean NOT NULL DEFAULT false;

CREATE INDEX ON calls(suspicious);

-- Purchases
ALTER TABLE purchases
    ADD COLUMN suspicious boolean NOT NULL DEFAULT false;

CREATE INDEX ON purchases(suspicious);

-- Emails
ALTER TABLE emails
    ADD COLUMN suspicious boolean NOT NULL DEFAULT false;

CREATE INDEX ON emails(suspicious);

-- Meetings
ALTER TABLE meetings
    ADD COLUMN suspicious boolean NOT NULL DEFAULT false;

CREATE INDEX ON meetings(suspicious);