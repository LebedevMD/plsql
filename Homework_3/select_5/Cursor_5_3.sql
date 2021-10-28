--Выдать все талоны конкретного врача, не показывать талоны которые начались раньше текущего времени
declare
    v_id_doc number;
begin
    select d.ID_Doctor into v_id_doc from LEBEDEV_MA.DOCTORS d where d.SURNAME = 'Лебедев';
    for i in (select d.Name as Доктор, t.STARTDATE as Начало, t.ENDDATE as Конец
        from LEBEDEV_MA.DOCTORS d join LEBEDEV_MA.TALON t on d.ID_DOCTOR = t.ID_DOCTOR where t.STARTDATE >= sysdate and d.ID_DOCTOR = v_id_doc)
    loop
        DBMS_OUTPUT.put_line(i.Доктор || '; ' || to_char(i.Начало, 'dd.mm.yy hh24:mi') || ' - ' || to_char(i.Конец, 'dd.mm.yy hh24:mi'));
    end loop;
end;