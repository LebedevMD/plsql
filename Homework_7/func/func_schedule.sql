--Выдать расписание больниц

--Основная часть
declare
    v_arr_schedule LEBEDEV_MA.T_ARR_HOSPITAL_SCHEDULE;
begin
    select LEBEDEV_MA.T_SCHEDULE(
        dayOfWeek => sch.DAYOFWEEK,
        start_work => sch.START_WORK,
        end_work => sch.END_WORK
   )
    bulk collect into v_arr_schedule
    from
         LEBEDEV_MA.SCHEDULE sch;
    for i in v_arr_schedule.first..v_arr_schedule.last
    loop
        declare
            v_item LEBEDEV_MA.t_schedule;
        begin
            v_item := v_arr_schedule(i);
            DBMS_OUTPUT.put_line(v_item.DayOfWeek || ': '
            || to_char(v_item.START_WORK, 'hh24:mi') || ' - ' || to_char(v_item.END_WORK, 'hh24:mi'));
        end;
    end loop;
end;
