CREATE TABLE IF NOT EXISTS photoready.people (
    code char(5) CONSTRAINT firstkey PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(100) NOT NULL
);