CREATE KEYSPACE IF NOT EXISTS users_service
WITH REPLICATION = { 
  'class' : 'SimpleStrategy', 
  'replication_factor' : 1 
};

USE users_service;

CREATE TABLE IF NOT EXISTS "users" (
  row_id TEXT,
  aggregate_id TEXT,
  event_time TIMESTAMP,
  event_type TEXT,
  payload TEXT,
  PRIMARY KEY(row_id, aggregate_id, event_time)
);
