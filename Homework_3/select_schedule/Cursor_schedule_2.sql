--Выдать расписание больниц
declare
    v_cursor_1 sys_refcursor;
    type record_1 is record (mo_Name varchar2(999), h_ID_Hospital number, DayOfWeek varchar2(11), START_WORK date, END_WORK date);
    v_record_schedule record_1;
begin
    DBMS_OUTPUT.enable();
    open v_cursor_1 for select mo.Name as Назв_МедОрг, h.ID_Hospital as Айди_больницы, sch.DayOfWeek as День_недели, sch.START_WORK as Начало_работы, sch.END_WORK as Конец_работы
        from LEBEDEV_MA.SCHEDULE sch join LEBEDEV_MA.HOSPITALS h on sch.ID_HOSPITAL = h.ID_HOSPITAL join LEBEDEV_MA.MED_ORGANISATIONS mo on h.ID_MEDORGAN = mo.ID_MED_ORGANISATION;
    loop
        fetch v_cursor_1 into v_record_schedule;
        exit when v_cursor_1%notfound;
        DBMS_OUTPUT.put_line(v_record_schedule.mo_Name || ' (' || v_record_schedule.h_ID_Hospital || '); ' || v_record_schedule.DayOfWeek || ': '
            || to_char(v_record_schedule.START_WORK, 'hh24:mi') || ' - ' || to_char(v_record_schedule.END_WORK, 'hh24:mi'));
    end loop;
    close v_cursor_1;
end;