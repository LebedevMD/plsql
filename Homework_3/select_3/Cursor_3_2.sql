--*Выдать все больницы (неудаленные) конкретной специальности с пометками о доступности, кол-ве врачей;
--отсортировать по типу: частные выше, по кол-ву докторов: где больше выше
declare
    v_cursor_hosp sys_refcursor;
    type record_1 is record(ID_Hospital number, ISAvailable number, countDoctors number, nameMedOrgan varchar2(500), specName varchar2(100));
    v_record_hospitals record_1;
    v_spec_name varchar2(50);
begin
    DBMS_OUTPUT.ENABLE();
    v_spec_name := 'Терапевт';
    open v_cursor_hosp for select h.ID_HOSPITAL as Айди_филиала, h.ISAVAILABLE as Доступность, count(d.Name) as Колво_врачей,
        mo.Name as Мед_Организация, sp.Name as Специальность
        from LEBEDEV_MA.HOSPITALS h join LEBEDEV_MA.MED_ORGANISATIONS mo on h.ID_MEDORGAN = mo.ID_MED_ORGANISATION join LEBEDEV_MA.HOSPITAL_SPECIALITY hossp on h.ID_HOSPITAL = hossp.ID_HOSPITAL
        join LEBEDEV_MA.SPECIALITY sp on hossp.ID_SPECIALITY = sp.ID_SPECIALITY join LEBEDEV_MA.DOCTORS d on sp.ID_SPECIALITY = d.ID_SPECIALITY
        where sp.NAME = v_spec_name group by h.ID_HOSPITAL, h.ISAVAILABLE, sp.Name, mo.NAME, h.ID_TYPE order by case when h.ID_HOSPITAL = 1 then 1 else 0 end;
    fetch v_cursor_hosp into v_record_hospitals;
    DBMS_OUTPUT.PUT_LINE('Специальность: ' || v_record_hospitals.specName);
    loop
        DBMS_OUTPUT.PUT_LINE('ID_Больницы: ' || v_record_hospitals.ID_Hospital);
        DBMS_OUTPUT.PUT_LINE('Доступность: ' || v_record_hospitals.ISAvailable);
        DBMS_OUTPUT.PUT_LINE('Кол-во докторов: ' || v_record_hospitals.countDoctors);
        DBMS_OUTPUT.PUT_LINE('Название мед. организации: ' || v_record_hospitals.nameMedOrgan);
        fetch v_cursor_hosp into v_record_hospitals;
        exit when v_cursor_hosp%notfound;
    end loop;
    close v_cursor_hosp;
end;