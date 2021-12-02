--*Выдать все больницы (неудаленные) конкретной специальности с пометками о доступности;
--отсортировать по типу: частные выше, по кол-ву докторов: где больше выше

--Основная часть
declare
    v_hospitals LEBEDEV_MA.T_HOSPITAL;
    v_spec_name varchar2(50);
    v_arr_hospital LEBEDEV_MA.T_ARR_HOSPITALS;
begin
    DBMS_OUTPUT.ENABLE();
    v_spec_name := 'Хирург';
    select LEBEDEV_MA.T_HOSPITAL(
                med_organisation => mo.NAME,
                isAvailable => h.ISAVAILABLE,
                type_name => tp.NAME,
                address => h.ADDRESS
   )
    bulk collect into v_arr_hospital
    from
         LEBEDEV_MA.HOSPITALS h
         join LEBEDEV_MA.MED_ORGANISATIONS mo on h.ID_MEDORGAN = mo.ID_MED_ORGANISATION
         join LEBEDEV_MA.HOSPITAL_SPECIALITY hossp on h.ID_HOSPITAL = hossp.ID_HOSPITAL
         join LEBEDEV_MA.SPECIALITY sp on hossp.ID_SPECIALITY = sp.ID_SPECIALITY
         join LEBEDEV_MA.DOCTORS d on sp.ID_SPECIALITY = d.ID_SPECIALITY
         join LEBEDEV_MA.TYPE tp on h.ID_TYPE = tp.ID_TYPE
    where
          ((sp.NAME = v_spec_name)
            or (sp.NAME is not null and v_spec_name is null))
    group by
             h.ISAVAILABLE,
             mo.NAME,
             tp.Name,
             h.ADDRESS,
             tp.ID_TYPE
    order by
             case when tp.ID_TYPE = LEBEDEV_MA.PKG_HOSPITALS.C_HOSPITAL_PRIVATE
                 then 1 else 0 end;



        DBMS_OUTPUT.PUT_LINE('Специальность: ' || v_spec_name);
    for i in v_arr_hospital.first..v_arr_hospital.LAST
    loop
    declare
        v_item LEBEDEV_MA.t_hospital;
    begin
        v_item := v_arr_hospital(i);
        DBMS_OUTPUT.PUT_LINE('Тип: ' || v_item.TYPE_NAME);
        DBMS_OUTPUT.PUT_LINE('Доступность: ' || v_item.ISAvailable);
        DBMS_OUTPUT.PUT_LINE('Название мед. организации: ' || v_item.MED_ORGANISATION);
        DBMS_OUTPUT.PUT_LINE('Адресс: ' || v_item.ADDRESS);
    end;
    end loop;
end;