### Demo - MySQL
Deploys a cluster of MySQL database. Uses 'openebs-hostpath' as storage class.
Installs OpenEBS in the proccess.

To access command line interface after installation:
- Track where the user/password is configured from the helm chart (e.g. in the values.yaml/secret)
- Run the command `mysql -u <user> -p` inside the pod's container

Common commands:
```
CREATE DATABASE <db_name>;
SHOW DATABASES;
USE DATABASE;
SHOW TABLES;
CREATE TABLE <table_name> (...);
INSERT INTO <table_name> (...) VALUES (...);
SELECT <columns> FROM <table_name>;
```
