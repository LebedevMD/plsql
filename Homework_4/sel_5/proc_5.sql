--Выдать все талоны конкретного врача, не показывать талоны которые начались раньше текущего времени

--Процедура
create or replace procedure LEBEDEV_MA.show_all_talon_by_id_doctor(
    p_id_doc number
)
    as
        v_cursor_talon sys_refcursor;
        type t_record_talon is
            record (
                Name varchar2(100),
                StartDate date,
                EndDate date);
        v_doctors t_record_talon;
    begin
        open v_cursor_talon for
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

--Основная часть
declare
    v_id_doc number;
begin
    select d.ID_Doctor into v_id_doc from LEBEDEV_MA.DOCTORS d where d.SURNAME = 'Лебедев';
    LEBEDEV_MA.show_all_talon_by_id_doctor(p_id_doc => v_id_doc);
end;