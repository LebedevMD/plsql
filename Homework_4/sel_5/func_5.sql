--Выдать все талоны конкретного врача, не показывать талоны которые начались раньше текущего времени

--Функция
create or replace function LEBEDEV_MA.get_all_talon_by_id_doctor(
    p_id_doc number
)
    return sys_refcursor
    as
        v_cursor sys_refcursor;
    begin
        open v_cursor for
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
        return v_cursor;
    end;

--Основная часть
declare
    v_cursor_talon sys_refcursor;
    type t_record_talon is
        record (
            Name varchar2(100),
            StartDate date,
            EndDate date);
    v_doctors t_record_talon;
    v_id_doc number;
begin
    DBMS_OUTPUT.ENABLE();
    select d.ID_Doctor into v_id_doc from LEBEDEV_MA.DOCTORS d where d.SURNAME = 'Лебедев';
    v_cursor_talon := LEBEDEV_MA.get_all_talon_by_id_doctor(p_id_doc => v_id_doc);
    fetch v_cursor_talon into v_doctors;
    if(v_cursor_talon%found) then
        loop
            DBMS_OUTPUT.PUT_LINE(v_doctors.Name || '; ' ||
                                 to_char(v_doctors.StartDate, 'dd.mm.yy hh24:mi') || ' - ' || to_char(v_doctors.EndDate, 'dd.mm.yy hh24:mi'));
            fetch v_cursor_talon into v_doctors;
            exit when v_cursor_talon%notfound;
        end loop;
    else
        DBMS_OUTPUT.PUT_LINE('Талонов для данного врача раньше текущего времени не найдено');
    end if;
    close v_cursor_talon;
end;