--Выдать всех врачей (неудаленных) конкретной больницы
-- отсортировать по квалификации: у кого есть выше, по участку: если участок совпадает с участком пациента, то такие выше

--Основная часть
declare
    v_area varchar2(10);
    v_address varchar2(500);
    v_arr_doctors LEBEDEV_MA.T_ARR_DOCTORS;
begin
    DBMS_OUTPUT.ENABLE();
    v_area := '2';
    v_address := 'Октябрьский проспект, 22';
    select LEBEDEV_MA.t_doctors(
        surname => d.SURNAME,
        name => d.Name,
        PATRONYMIC => d.PATRONYMIC,
        gender => g.Name,
        spec_name => s.NAME,
        salary => d.SALARY,
        area => d.AREA,
        RATING => d.RATING
    )
    bulk collect into v_arr_doctors
    from
         LEBEDEV_MA.DOCTORS d
         join LEBEDEV_MA.SPECIALITY s on d.ID_SPECIALITY = s.ID_SPECIALITY
         join LEBEDEV_MA.GENDER g on d.ID_GENDER = g.ID_GENDER
         join LEBEDEV_MA.QUALIFICATION q on d.ID_QUALIFICATION = q.ID_QUALIFICATION
         join LEBEDEV_MA.HOSPITALS h on d.ID_HOSPITAL = h.ID_HOSPITAL
    where
          v_address is not null and h.ADDRESS = v_address
    order by
             q.ID_QUALIFICATION,
             case when d.AREA = v_area then 1 else 0 end;
    for i in v_arr_doctors.first..v_arr_doctors.LAST
    loop
        declare
            v_item LEBEDEV_MA.T_DOCTORS;
        begin
            v_item := v_arr_doctors(i);
            DBMS_OUTPUT.PUT_LINE(v_item.surname || ' ' || v_item.name || '; ' ||
                             v_item.gender || '; ' ||
                             v_item.SPEC_NAME || '; ' ||
                             v_item.salary || '; ' ||
                             v_item.area);
        end;
    end loop;
exception
    when NO_DATA_FOUND then
    LEBEDEV_MA.ADD_ERROR_LOG('func_4',
                '{"error":"' || sqlerrm
                ||'","value":"' || v_address
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}');
end;