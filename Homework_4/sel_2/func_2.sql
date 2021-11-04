--Выдать все специальности (неудаленные), в которых есть хотя бы один доктор (неудаленный), которые работают в больницах (неудаленных)

--Функция
create or replace function LEBEDEV_MA.get_all_speciality
    return sys_refcursor
    as
    v_cursor sys_refcursor;
    begin
        open v_cursor for
            select
                   sp.NAME as Специальность
            from
                LEBEDEV_MA.HOSPITALS h
                join LEBEDEV_MA.DOCTORS d on d.ID_HOSPITAL = h.ID_HOSPITAL
                join LEBEDEV_MA.SPECIALITY sp on d.ID_SPECIALITY = sp.ID_SPECIALITY
            where
                  d.DELETED is null and
                  sp.DELETED is null and
                  h.DELETED is null
            group by
                     sp.NAME;
        return v_cursor;
    end;

--Основная часть
declare
    v_cursor_spec sys_refcursor;
    type t_record_spec is
        record (
            SpecName varchar2(100));
    v_spec t_record_spec;
begin
    v_cursor_spec := LEBEDEV_MA.get_all_speciality();
    fetch v_cursor_spec into v_spec;
    if v_cursor_spec%found then
        loop
            DBMS_OUTPUT.PUT_LINE(v_spec.SpecName);
            fetch v_cursor_spec into v_spec;
            exit when v_cursor_spec%notfound;
        end loop;
    else
        DBMS_OUTPUT.PUT_LINE('Специальности не найдены');
    end if;
    close v_cursor_spec;
end;