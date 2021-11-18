--Выдать всех врачей (неудаленных) конкретной больницы
-- отсортировать по квалификации: у кого есть выше, по участку: если участок совпадает с участком пациента, то такие выше

--Основная часть
declare
    v_area varchar2(10);
    v_id_hospital number;
begin
    v_area := '2';
    select h.ID_Hospital into v_id_hospital from LEBEDEV_MA.HOSPITALS h where h.ADDRESS = 'Октябрьский проспект, 22';
    DBMS_OUTPUT.PUT_LINE('Вывод с участком:');
    LEBEDEV_MA.PKG_HOSPITALS.SHOW_DOCTORS_BY_ID_HOSPITAL(p_id_hospital => v_id_hospital, p_area => v_area);
    DBMS_OUTPUT.PUT_LINE('Вывод без участка:');
    LEBEDEV_MA.PKG_HOSPITALS.SHOW_DOCTORS_BY_ID_HOSPITAL(p_id_hospital => v_id_hospital);
end;