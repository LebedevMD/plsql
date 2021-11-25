--Выдать все города по регионам
declare
    v_cursor_cities sys_refcursor;
    type record_city is record (NameCity varchar2(100), NameRegion varchar2(100));
    v_record_cities record_city;
    v_id_region number;
begin
    select r.ID_Region into v_id_region from LEBEDEV_MA.REGIONS r where r.Name = 'Республика Татарстан';
    open v_cursor_cities for
        select
               c.Name as Город,
               r.Name as Регион
        from LEBEDEV_MA.REGIONS r
            join LEBEDEV_MA.CITIES c on r.ID_REGION = C.ID_REGION
        where c.ID_REGION = v_id_region;
    fetch v_cursor_cities into v_record_cities;
    DBMS_OUTPUT.PUT_LINE('Регион: ' || v_record_cities.NameRegion);
    loop
        DBMS_OUTPUT.PUT_LINE(v_record_cities.NameCity);
        fetch v_cursor_cities into v_record_cities;
        exit when v_cursor_cities%notfound;
    end loop;
    close v_cursor_cities;
end;