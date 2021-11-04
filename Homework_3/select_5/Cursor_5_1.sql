--Выдать все талоны конкретного врача, не показывать талоны которые начались раньше текущего времени
declare
    cursor cursor_1 (p_id_doc number) is
        select
               d.Name as Доктор,
               t.STARTDATE as Начало,
               t.ENDDATE as Конец
        from
             LEBEDEV_MA.DOCTORS d
             join LEBEDEV_MA.TALON t on d.ID_DOCTOR = t.ID_DOCTOR
        where
              (t.STARTDATE >= sysdate and
                ((p_id_doc is not null and d.ID_DOCTOR = p_id_doc)
                or (p_id_doc is null and d.ID_DOCTOR is not null)));
    type record_1 is
        record (
            Name varchar2(100),
            StartDate date,
            EndDate date);
    v_record_doctors record_1;
    v_id_doc number;
begin
    DBMS_OUTPUT.ENABLE();
    select d.ID_Doctor into v_id_doc from LEBEDEV_MA.DOCTORS d where d.SURNAME = 'Лебедев';
    open cursor_1 (v_id_doc);
    fetch cursor_1 into v_record_doctors;
    if (cursor_1%found) then
        loop
            DBMS_OUTPUT.PUT_LINE(
                v_record_doctors.Name ||
                '; ' ||
                to_char(v_record_doctors.StartDate, 'dd.mm.yy hh24:mi') ||
                ' - ' ||
                to_char(v_record_doctors.EndDate, 'dd.mm.yy hh24:mi'));
            fetch cursor_1 into v_record_doctors;
            exit when cursor_1%notfound;
        end loop;
    else
        DBMS_OUTPUT.put_line('Талонов не найдено(');
    end if;
    close cursor_1;
end;