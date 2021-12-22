--Плановая задача кэширование доктора

--Создание задачи
begin
    sys.dbms_scheduler.create_job(
        job_name        => 'LEBEDEV_MA.job_doctors_cash',
        start_date      => to_timestamp_tz('2021/12/24 09:00:00.000000 +07:00','yyyy/mm/dd hh24:mi:ss.ff tzh:tzm'),
        repeat_interval => 'FREQ=HOURLY;INTERVAL=1;',
        end_date        => null,
        job_class       => 'DEFAULT_JOB_CLASS',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'begin LEBEDEV_MA.action_cash; end;',
        comments        => 'Кэширование доктора'
    );
    sys.dbms_scheduler.set_attribute(
        name      => 'LEBEDEV_MA.job_doctors_cash',
        attribute => 'RESTART_ON_RECOVERY',
        value     => true
    );
    sys.dbms_scheduler.set_attribute(
        name      => 'LEBEDEV_MA.job_doctors_cash',
        attribute => 'RESTART_ON_FAILURE',
        value     => true
    );
end;

--просмотр списка задач вида SCHEDULE
select * from user_scheduler_jobs;

--просмотр логов
select * from user_scheduler_job_log;

--запуск задачи
begin
    sys.dbms_scheduler.enable(
        name      => 'LEBEDEV_MA.job_doctors_cash'
    );
end;

--остановка задачи
begin
    sys.dbms_scheduler.disable(
        name      => 'LEBEDEV_MA.job_doctors_cash'
    );
end;

--удаление задачи
begin
    sys.dbms_scheduler.drop_job(
        job_name      => 'LEBEDEV_MA.job_doctors_cash'
    );
end;

--Процедура кэширования
create or replace procedure LEBEDEV_MA.action_cash
as
    v_clob clob;
    v_result number;
    v_arr_doctors LEBEDEV_MA.t_arr_doctors_dto;
begin
    v_clob := LEBEDEV_MA.REPOSITORY_DOCTOR.GET_FROM_ANOTHER_SYSTEM(v_result);
    if (v_result != LEBEDEV_MA.PKG_CODES.C_ERROR) then
        v_arr_doctors := LEBEDEV_MA.REPOSITORY_DOCTOR.DESERIALIZATION(v_clob, v_result);
    end if;
    if (v_result != LEBEDEV_MA.PKG_CODES.C_ERROR) then
        LEBEDEV_MA.REPOSITORY_DOCTOR.MERGE(v_arr_doctors, v_result);
    end if;
    commit;
end;
