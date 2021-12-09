--Плановая задача доктор

--Создание задачи
begin
    sys.dbms_scheduler.create_job(
        job_name        => 'LEBEDEV_MA.job_cash_doctors',
        start_date      => to_timestamp_tz('2021/12/10 09:00:00.000000 +07:00','yyyy/mm/dd hh24:mi:ss.ff tzh:tzm'),
        repeat_interval => 'FREQ=HOURLY;INTERVAL=1;',
        end_date        => null,
        job_class       => 'DEFAULT_JOB_CLASS',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'begin LEBEDEV_MA.controller_doctor; end;',
        comments        => 'Кэширование доктора'
    );
    sys.dbms_scheduler.set_attribute(
        name      => 'LEBEDEV_MA.job_cash_doctors',
        attribute => 'RESTART_ON_RECOVERY',
        value     => false
    );
    sys.dbms_scheduler.set_attribute(
        name      => 'LEBEDEV_MA.job_cash_doctors',
        attribute => 'RESTART_ON_FAILURE',
        value     => false
    );
end;

--просмотр списка задач вида SCHEDULE
select * from user_scheduler_jobs;

--просмотр логов
select * from user_scheduler_job_log;

--запуск задачи
begin
    sys.dbms_scheduler.enable(
        name      => 'LEBEDEV_MA.job_cash_doctors'
    );
end;

--остановка задачи
begin
    sys.dbms_scheduler.disable(
        name      => 'LEBEDEV_MA.job_cash_doctors'
    );
end;

--удаление задачи
begin
    sys.dbms_scheduler.drop_job(
        job_name      => 'LEBEDEV_MA.job_cash_doctors'
    );
end;