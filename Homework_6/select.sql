--select запрос в анонимном блоке для вывода логов
select *
from (
        select
            el.ID_LOG,
            el.LOG_DATE,
            el.OBJECT_NAME,
           (select error
             from json_table(el.PARAMS, '$' columns(
                 error varchar2(300) path '$.error'
             ))) error,
            el.PARAMS
        from LEBEDEV_MA.ERROR_LOGGING el
      ) er
where
    er.LOG_DATE > to_date('24.11.2021 12:00', 'dd.mm.yyyy hh24:mi')
    and er.LOG_DATE < to_date('25.11.2021 21:45', 'dd.mm.yyyy hh24:mi')
    and er.OBJECT_NAME = 'LEBEDEV_MA.check_appointment'
    and er.error like 'ORA-20001%'
;
