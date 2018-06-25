-- Initialization for metabase database

DROP DATABASE IF EXISTS metabase;

CREATE DATABASE metabase OWNER infoviz;

\c metabase infoviz;
