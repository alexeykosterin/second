Установка
	--2.1 Проверим, что в INSIS ничего не работает. Смотрим сессии. Если что-то работает, например job пролонгации, то останавливаем
	--2.2 ДО 18-00 выключаем джобы !!!!!!
	
select s.sql_text, v.sid, v.status, v.serial#, OSUSER, USERNAME, MACHINE, v.* from v$session v, v$sql s WHERE status != 'INACTIVE'
AND OSUSER = 'ba931257'
AND s.sql_id(+) = v.sql_id AND v.TYPE = 'USER'



BEGIN 
	FOR rec IN (select v.sid, v.status, v.serial#, OSUSER, USERNAME, MACHINE from v$session v WHERE status != 'INACTIVE'
	AND OSUSER != 'a.kosterin' AND SERIAL# != 1 AND STATUS NOT IN ('INACTIVE', 'KILLED') AND v.TYPE = 'USER'
	AND MACHINE NOT LIKE '%PROD-XTR-AS01%' AND OSUSER != 's-xtractor-2')
	LOOP 
		EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION '''||rec.SID||','||rec.SERIAL#||''' IMMEDIATE';
	END LOOP;
END;

select l.session_id, l.owner, l.name, l.type, inst_id, sql_id
     , a.sql_fulltext
     , 'alter system disconnect session '''||s.sid||','||s.serial#||',@'||inst_id||''' immediate' ddl
  from dba_ddl_locks l 
  join gv$session s on s.sid = l.session_id
  join gv$sqlarea a using(inst_id, sql_id)
 where l.name = 'CUST_UTIL_PKG'
;


CREATE TABLE "INSIS_SGI_DEV"."AAK_TMP_SCHEDULED_JOBS" 
   (	"JOB_NAME" VARCHAR2(100), 
	"ACTION_DATE" DATE
   )
	--disable jobs
	declare 
		l_enabled_jobs_count NUMBER;
	begin 
	  select count(*) into l_enabled_jobs_count from SYS.DBA_SCHEDULER_JOBS where OWNER like 'INSIS%' and state = 'SCHEDULED' and ENABLED = 'TRUE';
	  IF l_enabled_jobs_count > 0
	  THEN
		begin
		execute immediate 'drop table insis_sgi_dev.tmp_scheduled_jobs';
		exception when others then null;
		end;
		execute immediate 'create table insis_sgi_dev.tmp_scheduled_jobs as
		select JOB_NAME from SYS.DBA_SCHEDULER_JOBS where OWNER like ''INSIS%'' and state = ''SCHEDULED'' and ENABLED = ''TRUE''';
	  END IF;
	  for rec in (select JOB_NAME from insis_sgi_dev.tmp_scheduled_jobs) 
	  loop 
		INSIS_SCHEDULER.SCHEDULER_ADMIN.Disable( pi_object_name => rec.JOB_NAME, pi_force => FALSE ); 
	  end loop; 
	  commit;
	end; 
	/
	
DECLARE
	TYPE list_job_name IS TABLE OF insis_sgi_dev.aak_tmp_scheduled_jobs.JOB_NAME%TYPE INDEX BY PLS_INTEGER;
	l_collect list_job_name;
	l_row PLS_INTEGER := 1;
	l_cnt NUMBER;
BEGIN
	DELETE FROM insis_sgi_dev.aak_tmp_scheduled_jobs WHERE trunc(action_date) < trunc(sysdate);
	FOR rec IN (select JOB_NAME from SYS.DBA_SCHEDULER_JOBS where OWNER like 'INSIS%' and state = 'SCHEDULED' and ENABLED = 'TRUE')
	LOOP 
		SELECT count(1) INTO l_cnt FROM insis_sgi_dev.aak_tmp_scheduled_jobs WHERE trunc(action_date) = trunc(sysdate)
		AND job_name = rec.JOB_NAME;
		IF l_cnt = 0 THEN
			l_collect(l_row) := rec.JOB_NAME;
			l_row := l_row + 1;
		END IF;
	END LOOP;
	l_row := l_collect.FIRST;
	WHILE (l_row IS NOT NULL)
	LOOP
		--dbms_output.put_line(l_collect(l_row));
		INSERT INTO insis_sgi_dev.aak_tmp_scheduled_jobs (JOB_NAME, ACTION_DATE) VALUES (l_collect(l_row), TRUNC(SYSDATE));
		INSIS_SCHEDULER.SCHEDULER_ADMIN.Disable( pi_object_name => l_collect(l_row), pi_force => FALSE );
		l_row := l_collect.NEXT(l_row);
	END LOOP;
END;
	
COMMISSION_INSTALLMENTS
SEND_DCB_NOTIFICATIONS
CALC_ADDITIONAL_INCOME
FOREIGN_DOC_STATE_UPDATE_JOB
JOB_SCREENING
GET_RSB_CURRENCIES
SGI_MORT_SMS_INVOICE_SENT_JOB
TRANSF_POLS_BLC
UPDATE_SAVINGS_STATE
LOAD_BANK_LIST_JOB
JOB_GET_CB_KEYRATE
JOB_PL_PF_CLIENT_1YEAR
JOB_DCB_MORTGAGE_SIB_UPDATE
NOTIF_CHAIN_JOB
PRNT_UL_QUARTERLY_REPORT
GET_CBR_CURRENCIES
VW_ICS_CLAIM_REFRESH_JOB
INTEGRATION_CHAIN_JOB
MAIN_CHAIN_JOB
TRANSF_R2_BLC
COLLECT_DCB_NOTIFICATIONS

	--2.3 Проверь релизные задачи, они должны быть слинкованы к таску установки релиза, проверить что задача ASSIGN , висит на SGI_Bamboo, плюс есть файл IT_C1_UAT_INSIS%
	--2.4 Заходим в bamboo, insis, выбираем последнюю установку на ТЕСТ, RUN Stage PROD - Run
	--2.5 CompileInvalidObjects
	SET serveroutput ON;
	BEGIN
		FOR r IN
		(
			SELECT owner || '.' || object_name AS synname,
				object_type,
				status,
				CASE
					WHEN object_type = 'JAVA CLASS'
					THEN
						'ALTER JAVA CLASS "' || owner || '"."' || object_name || '" RESOLVE'
					WHEN object_type = 'RULE SET'
					THEN
						'BEGIN dbms_ruleadm_internal.validate_re_object(''' || owner || '.' || object_name || ''', 23); END;'
					WHEN object_type = 'RULE'
					THEN
						'BEGIN dbms_ruleadm_internal.validate_re_object(''' || owner || '.' || object_name || ''', 36); END;'
					WHEN object_type = 'EVALUATION CONTEXT'
					THEN
						'BEGIN dbms_ruleadm_internal.validate_re_object(''' || owner || '.' || object_name || ''', 38); END;'
					ELSE
						'ALTER ' || replace(object_type, ' BODY') || ' ' || owner || '.' || object_name || ' compile ' || CASE WHEN object_type LIKE '%BODY%' THEN 'BODY' END
			END AS compile_stmt
			FROM sys.dba_objects
			WHERE owner LIKE 'INSIS_%'
				AND status != 'VALID'
				AND owner NOT IN ('INSIS_LIFE_CUST', 'INSIS_HLT_V10_RLS', 'INSIS_GEN_V10_NAS', 'INSIS_IBNR', 'INSIS_AMX')
				AND object_type NOT IN ('QUEUE')
		)
		LOOP
			BEGIN
				EXECUTE IMMEDIATE r.compile_stmt;
				   
				EXCEPTION
					WHEN OTHERS
					THEN
						dbms_output.put_line('Error compiling ' || lower(r.object_type) || ' ' || r.synname || ': ' || SQLERRM);
			END;
		END LOOP;
	END;
	--2.6 Запускаем джобы
	--enable jobs
	begin 
	  for rec in (select DISTINCT JOB_NAME from insis_sgi_dev.aak_tmp_scheduled_jobs) 
	  loop 
		INSIS_SCHEDULER.SCHEDULER_ADMIN.Enable( pi_object_name => rec.JOB_NAME ); 
	  end loop; 
	  commit;
	end; 
	/	

	
--3. После релиза пишем письмо
--4. Перезапустить "wlsvc INSIS_InsisSrv04" service on rswdapp33 (STOP and START)	НА СЛЕДУЮЩИЙ ДЕНЬ ПОСЕ РЕЛИЗА С УТРА!!!

--если упал на Finalized, но задачи поставились, то перезапустить шаг Rerun failed
--Если произошла ошибка во время установки релиза!!!!!!!!!!!!!!!!

--1. Откатываемся в обратном порядке на дорелизные снапшоты
--2. Запускаем на 33 виртуалке в диске D папка start_stop_insis - start - start all (от админа)
--3. Компилим инвалидов
--4. Запускаем джобы
--5. Пишем письмо о восстановлении работы insis


SELECT p.policy_state, p.* FROM
insis_sgi_dev.smoke_policy_registry r
LEFT JOIN insis_gen_v10.policy p ON p.policy_no = r.policy_no