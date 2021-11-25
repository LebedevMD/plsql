--Выдать все талоны конкретного врача, не показывать талоны которые начались раньше текущего времени

--Основная часть
declare
    v_doctors LEBEDEV_MA.PKG_TALON.T_RECORD_TALON;
    v_id_doc number;
    v_surname_doc varchar2(50);
begin
    DBMS_OUTPUT.ENABLE();
    v_surname_doc := 'Козлов';
    select d.ID_Doctor into v_id_doc from LEBEDEV_MA.DOCTORS d where d.SURNAME = v_surname_doc;
    open LEBEDEV_MA.pkg_doctors.v_cursor_talon(p_id_doc => v_id_doc);
    fetch LEBEDEV_MA.pkg_doctors.v_cursor_talon into v_doctors;
    if(LEBEDEV_MA.pkg_doctors.v_cursor_talon%found) then
        loop
            DBMS_OUTPUT.PUT_LINE(v_doctors.Name || '; ' ||
                                 to_char(v_doctors.StartDate, 'dd.mm.yy hh24:mi') || ' - ' || to_char(v_doctors.EndDate, 'dd.mm.yy hh24:mi'));
            fetch LEBEDEV_MA.pkg_doctors.v_cursor_talon into v_doctors;
            exit when LEBEDEV_MA.pkg_doctors.v_cursor_talon%notfound;
        end loop;
    else
        DBMS_OUTPUT.PUT_LINE('Талонов для данного врача раньше текущего времени не найдено');
    end if;
    close LEBEDEV_MA.pkg_doctors.v_cursor_talon;
exception
    when NO_DATA_FOUND then
    LEBEDEV_MA.ADD_ERROR_LOG('func_5',
                '{"error":"' || sqlerrm
                ||'","value":"' || v_surname_doc
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}');
end;