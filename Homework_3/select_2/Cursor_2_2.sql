--Выдать все специальности (неудаленные), в которых есть хотя бы один доктор (неудаленный), которые работают в больницах (неудаленных)
declare
    v_cursor_spec sys_refcursor;
    type record_spec is record (SpecName varchar2(100));
    v_record_spec record_spec;
begin
    open v_cursor_spec for select sp.NAME as Специальность from LEBEDEV_MA.HOSPITALS h join LEBEDEV_MA.DOCTORS d on d.ID_HOSPITAL = h.ID_HOSPITAL
        join LEBEDEV_MA.SPECIALITY sp on d.ID_SPECIALITY = sp.ID_SPECIALITY where d.DELETED is null and sp.DELETED is null and h.DELETED is null group by sp.NAME;
    loop
        fetch v_cursor_spec into v_record_spec;
        exit when v_cursor_spec%notfound;
        DBMS_OUTPUT.PUT_LINE(v_record_spec.SpecName);
    end loop;
    close v_cursor_spec;
end;