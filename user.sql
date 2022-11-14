--criando a database uvv
CREATE DATABASE "uvv"
  WITH OWNER = lia
       ENCODING = 'UTF8'
       TEMPLATE = template0
       LC_COLLATE = 'Portuguese_Brazil.1252'
       LC_CTYPE = 'Portuguese_Brazil.1252'
       ALLOW_CONNECTIONS = true
       TABLESPACE = pg_default
	   IS_TEMPLATE = False;


--criando schema hr
CREATE SCHEMA hr AUTHORIZATION lia;

--tornando hr o schema principal
ALTER USER lia
SET SEARCH_PATH TO hr, "$user", public;