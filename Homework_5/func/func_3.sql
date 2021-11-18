--*Выдать все больницы (неудаленные) конкретной специальности с пометками о доступности, кол-ве врачей;
--отсортировать по типу: частные выше, по кол-ву докторов: где больше выше

--Основная часть
declare
    v_cursor_hosp sys_refcursor;
    type t_record_hospital is
        record(
            ID_Hospital number,
            ISAvailable number,
            typeHosp varchar2(20),
            countDoctors number,
            nameMedOrgan varchar2(500),
            specName varchar2(100));
    v_hospitals t_record_hospital;
    v_spec_name varchar2(50);
begin
    DBMS_OUTPUT.ENABLE();
    v_spec_name := 'Хирург';
    v_cursor_hosp := LEBEDEV_MA.PKG_SPECIALITY.GET_CURSOR_HOSP_BY_SPEC_NAME(p_spec_name => v_spec_name);
    fetch v_cursor_hosp into v_hospitals;
    if v_cursor_hosp%found then
        DBMS_OUTPUT.PUT_LINE('Специальность: ' || v_hospitals.specName);
        loop
            DBMS_OUTPUT.PUT_LINE('ID_Больницы: ' || v_hospitals.ID_Hospital);
            DBMS_OUTPUT.PUT_LINE('Тип: ' || v_hospitals.typeHosp);
            DBMS_OUTPUT.PUT_LINE('Доступность: ' || v_hospitals.ISAvailable);
            DBMS_OUTPUT.PUT_LINE('Кол-во докторов: ' || v_hospitals.countDoctors);
            DBMS_OUTPUT.PUT_LINE('Название мед. организации: ' || v_hospitals.nameMedOrgan);
            fetch v_cursor_hosp into v_hospitals;
            exit when v_cursor_hosp%notfound;
        end loop;
    else
        DBMS_OUTPUT.PUT_LINE('Больниц по данной специальности не найдено');
    end if;
    close v_cursor_hosp;
end;