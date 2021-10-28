--Выдать расписание больниц
begin
    for i in (select mo.Name as Назв_МедОрг, h.ID_Hospital as Айди_больницы, sch.DayOfWeek as День_недели, sch.START_WORK as Начало_работы, sch.END_WORK as Конец_работы
        from LEBEDEV_MA.SCHEDULE sch join LEBEDEV_MA.HOSPITALS h on sch.ID_HOSPITAL = h.ID_HOSPITAL join LEBEDEV_MA.MED_ORGANISATIONS mo on h.ID_MEDORGAN = mo.ID_MED_ORGANISATION)
    loop
        DBMS_OUTPUT.put_line(i.Назв_МедОрг || ' (' || i.Айди_больницы || '); ' || i.День_недели || ': '
            || to_char(i.Начало_работы, 'hh24:mi') || ' - ' || to_char(i.Конец_работы, 'hh24:mi'));
    end loop;
end;