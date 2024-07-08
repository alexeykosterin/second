do
$$DECLARE
lv_user_name varchar(100) :=  'RUS_SERVICE';
lv_pass varchar(100) := 'PG21*0^n^8G8';
begin
execute 'create user '||lv_user_name||' with encrypted password '''||lv_pass||''';';
execute 'create schema authorization '||lv_user_name||';';
end$$;;

create tablespace SOGECAP owner RUS_SERVICE location '/var/lib/pgsql/14/data/PG_SOGECAP';
create tablespace USERS owner RUS_SERVICE location '/var/lib/pgsql/14/data/PG_USERS';
create tablespace SYSTEM owner RUS_SERVICE location '/var/lib/pgsql/14/data/PG_SYSTEM';


---grant usage on schema rus_service to ics
---grant create on schema icsatt to ics
---alter default privileges for role ics in schema rus_service grant select, insert, update on tables to ics
---grant select,insert,update, delete on all tables in schema rus_service to ics
---grant usage, select on all sequences in schema ics to icsatt

