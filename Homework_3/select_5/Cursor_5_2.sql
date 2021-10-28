--Выдать все талоны конкретного врача, не показывать талоны которые начались раньше текущего времени
declare
    v_cursor_1 sys_refcursor;
    type record_1 is record (Name varchar2(100), StartDate date, EndDate date);
    v_record_doctors record_1;
    v_id_doc number;
begin
    DBMS_OUTPUT.ENABLE();
    select d.ID_Doctor into v_id_doc from LEBEDEV_MA.DOCTORS d where d.SURNAME = 'Лебедев';
    open v_cursor_1 for select d.Name as Доктор, t.STARTDATE as Начало, t.ENDDATE as Конец
        from LEBEDEV_MA.DOCTORS d join LEBEDEV_MA.TALON t on d.ID_DOCTOR = t.ID_DOCTOR where t.STARTDATE >= sysdate and d.ID_DOCTOR = v_id_doc;
    loop
        fetch v_cursor_1 into v_record_doctors;
        exit when v_cursor_1%notfound;
        DBMS_OUTPUT.PUT_LINE(v_record_doctors.Name || '; ' || to_char(v_record_doctors.StartDate, 'dd.mm.yy hh24:mi') || ' - ' || to_char(v_record_doctors.EndDate, 'dd.mm.yy hh24:mi'));
    end loop;
    close v_cursor_1;
end;