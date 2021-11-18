--Выдать все специальности (неудаленные), в которых есть хотя бы один доктор (неудаленный), которые работают в больницах (неудаленных)

--Основная часть
declare
    v_cursor_spec sys_refcursor;
    type t_record_spec is
        record (
            SpecName varchar2(100));
    v_spec t_record_spec;
begin
    v_cursor_spec := LEBEDEV_MA.PKG_SPECIALITY.GET_CURSOR_ALL_SPECIALITY();
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