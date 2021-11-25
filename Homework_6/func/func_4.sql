--Выдать всех врачей (неудаленных) конкретной больницы
-- отсортировать по квалификации: у кого есть выше, по участку: если участок совпадает с участком пациента, то такие выше

--Основная часть
declare
    v_area varchar2(10);
    v_id_hospital number;
    v_address varchar2(500);
begin
    DBMS_OUTPUT.ENABLE();
    v_area := '2';
    v_address := 'Октябрьский проспект, 20';
    select h.ID_Hospital into v_id_hospital from LEBEDEV_MA.HOSPITALS h where h.ADDRESS = v_address;
    DBMS_OUTPUT.PUT_LINE('Вывод с участком:');
    LEBEDEV_MA.PKG_HOSPITALS.SHOW_DOCTORS_BY_ID_HOSPITAL(p_id_hospital => v_id_hospital, p_area => v_area);
    DBMS_OUTPUT.PUT_LINE('Вывод без участка:');
    LEBEDEV_MA.PKG_HOSPITALS.SHOW_DOCTORS_BY_ID_HOSPITAL(p_id_hospital => v_id_hospital);
exception
    when NO_DATA_FOUND then
    LEBEDEV_MA.ADD_ERROR_LOG('func_4',
                '{"error":"' || sqlerrm
                ||'","value":"' || v_address
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}');
end;