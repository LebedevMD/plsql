--Выдать все города по регионам

--Процедура
create or replace procedure LEBEDEV_MA.all_cities_by_region(
    p_id_region in number,
    out_cursor out sys_refcursor
)
    as
    begin
        open out_cursor for
            select
                   c.Name as Город,
                   r.Name as Регион
            from
                 LEBEDEV_MA.REGIONS r
                 join LEBEDEV_MA.CITIES c on r.ID_REGION = C.ID_REGION
            where
                  ((p_id_region is not null and c.ID_REGION = p_id_region)
                    or(p_id_region is null and c.ID_REGION is not null));
    end;

--Основная часть
declare
    v_cursor_cities sys_refcursor;
    type t_record_city is
        record (
            NameCity varchar2(100),
            NameRegion varchar2(100));
    v_cities t_record_city;
    v_id_region number;
begin
    select r.ID_Region into v_id_region from LEBEDEV_MA.REGIONS r where r.NAME = 'Ленинградская область';
    LEBEDEV_MA.all_cities_by_region(p_id_region => v_id_region, out_cursor => v_cursor_cities);
    fetch v_cursor_cities into v_cities;
    if v_cursor_cities%found then
        loop
            DBMS_OUTPUT.PUT_LINE(v_cities.NameCity || '; ' || v_cities.NameRegion);
            fetch v_cursor_cities into v_cities;
            exit when v_cursor_cities%notfound;
        end loop;
    else
        DBMS_OUTPUT.PUT_LINE('Городов в данном регионе не найдено');
    end if;
    close v_cursor_cities;
end;