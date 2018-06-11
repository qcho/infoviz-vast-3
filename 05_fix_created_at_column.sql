-- Convert BigInteger to timestamp
-- Magic 1431352800 from:
-- SELECT extract(epoch from ('May 11, 2015 at 14:00 UTC' at time zone 'utc'));

ALTER TABLE calls
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

ALTER TABLE purchases
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

ALTER TABLE emails
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

ALTER TABLE meetings
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);

ALTER TABLE other_suspicious_purchases
    ALTER COLUMN created_at SET DATA TYPE timestamp without time zone
    USING to_timestamp(created_at + 1431352800);
