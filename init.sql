create database if not exists metabase collate utf8_bin;

GRANT ALL PRIVILEGES ON metabase.* TO 'dev'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
