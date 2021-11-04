--Выдать все специальности (неудаленные), в которых есть хотя бы один доктор (неудаленный), которые работают в больницах (неудаленных)

--Процедура
create or replace procedure LEBEDEV_MA.show_all_speciality
    as
        v_cursor_spec sys_refcursor;
        type t_record_spec is
            record (
                SpecName varchar2(100));
        v_spec t_record_spec;
    begin
    open v_cursor_spec for
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

--Основная часть
begin
    LEBEDEV_MA.show_all_speciality();
end;