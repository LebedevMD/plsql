--Выдать все города по регионам
declare
    cursor cursor_1 (p_id_region in number) is
        select
               c.Name as Город,
               r.Name as Регион
        from
             LEBEDEV_MA.REGIONS r
             join LEBEDEV_MA.CITIES c on r.ID_REGION = C.ID_REGION
        where
              ((p_id_region is not null and c.ID_REGION = p_id_region)
                or(p_id_region is null and c.ID_REGION is not null));
    type record_city is record (NameCity varchar2(100), NameRegion varchar2(100));
    v_record_city record_city;
    v_id_region number;
begin
    select r.ID_Region into v_id_region from LEBEDEV_MA.REGIONS r where r.NAME = 'Ленинградская область';
    open cursor_1(v_id_region);
    fetch cursor_1 into v_record_city;
            loop
                DBMS_OUTPUT.PUT_LINE(v_record_city.NameCity || '; ' || v_record_city.NameRegion);
                fetch cursor_1 into v_record_city;
                exit when cursor_1%notfound;
            end loop;
    close cursor_1;
end;