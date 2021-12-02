--Выдать все специальности (неудаленные), в которых есть хотя бы один доктор (неудаленный), которые работают в больницах (неудаленных)

--Основная часть
declare
    v_arr_spec LEBEDEV_MA.T_ARR_SPECIALITY;
begin
    DBMS_OUTPUT.ENABLE();
    select LEBEDEV_MA.T_SPECIALITY(
                name => sp.name,
                req_gender => gen.NAME,
                req_age_start_interval => rage.START_INTERVAL,
                req_age_end_interval => rage.END_INTERVAL
    )
    bulk collect into v_arr_spec
    from
        LEBEDEV_MA.HOSPITALS h
        join LEBEDEV_MA.DOCTORS d on d.ID_HOSPITAL = h.ID_HOSPITAL
        join LEBEDEV_MA.SPECIALITY sp on d.ID_SPECIALITY = sp.ID_SPECIALITY
        join LEBEDEV_MA.REQUIRED_GENDER rg on sp.ID_SPECIALITY = rg.ID_SPECIALITY
        join LEBEDEV_MA.GENDER gen on rg.ID_GENDER = gen.ID_GENDER
        join LEBEDEV_MA.REQUIRED_AGE rage on sp.ID_AGE_REQUIRED = rage.ID_REQUIRED_AGE
    where
          d.DELETED is null and
          sp.DELETED is null and
          h.DELETED is null;
    for i in v_arr_spec.first..v_arr_spec.LAST
    loop
        declare
            v_item LEBEDEV_MA.T_SPECIALITY;
        begin
            v_item := v_arr_spec(i);
            DBMS_OUTPUT.PUT_LINE(v_item.NAME);
        end;
    end loop;
end;