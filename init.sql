create database if not exists metabase collate utf8_bin;
create database if not exists testdb collate utf8_bin;

use testdb;
\. /opt/mysqlsampledatabase.sql

GRANT ALL PRIVILEGES ON metabase.* TO 'dev'@'%' WITH GRANT OPTION;
GRANT SELECT ON testdb.* TO 'dev'@'%';
FLUSH PRIVILEGES;
