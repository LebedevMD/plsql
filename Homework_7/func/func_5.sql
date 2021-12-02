--Выдать все талоны конкретного врача, не показывать талоны которые начались раньше текущего времени

--Основная часть
declare
    v_id_doc number;
    v_surname_doc varchar2(50);
    v_arr_talons LEBEDEV_MA.T_ARR_TALONS;
begin
    DBMS_OUTPUT.ENABLE();
    v_surname_doc := 'Лебедев';
    select d.ID_Doctor into v_id_doc from LEBEDEV_MA.DOCTORS d where d.SURNAME = v_surname_doc;

    select LEBEDEV_MA.T_TALON(
        id_doctor => d.ID_DOCTOR,
        isOpen => t.ISOPEN,
        startDate => t.STARTDATE,
        endDate => t.ENDDATE
    )
    bulk collect into v_arr_talons
    from
         LEBEDEV_MA.DOCTORS d
         join LEBEDEV_MA.TALON t on d.ID_DOCTOR = t.ID_DOCTOR
    where
          (t.STARTDATE >= sysdate and
            ((v_id_doc is not null and d.ID_DOCTOR = v_id_doc)
            or (v_id_doc is null)));

    for i in v_arr_talons.first..v_arr_talons.LAST
    loop
        declare
            v_item LEBEDEV_MA.T_TALON;
        begin
            v_item := v_arr_talons(i);
            DBMS_OUTPUT.PUT_LINE(v_item.ISOPEN || '; ' ||
                             to_char(v_item.StartDate, 'dd.mm.yy hh24:mi') || ' - ' || to_char(v_item.EndDate, 'dd.mm.yy hh24:mi'));
        end;
    end loop;

exception
    when NO_DATA_FOUND then
    LEBEDEV_MA.ADD_ERROR_LOG('func_5',
                '{"error":"' || sqlerrm
                ||'","value":"' || v_surname_doc
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}');
end;
