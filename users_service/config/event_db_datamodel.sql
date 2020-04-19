CREATE KEYSPACE IF NOT EXISTS users_service
WITH REPLICATION = { 
  'class' : 'SimpleStrategy', 
  'replication_factor' : 1 
};

USE users_service;

CREATE TABLE IF NOT EXISTS "users" (
  row_id TEXT,
  aggregate_id TEXT,
  timestamp TIMESTAMP,
  action TEXT,
  payload BLOB,
  PRIMARY KEY(row_id, aggregate_id, timestamp)
);
