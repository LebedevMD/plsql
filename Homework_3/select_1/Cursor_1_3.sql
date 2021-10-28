--Выдать все города по регионам
declare
    v_id_region number;
begin
    select r.ID_Region into v_id_region from LEBEDEV_MA.REGIONS r where r.NAME = 'Кемеровская область';
    for i in (
        select c.Name as Город, r.Name as Регион
        from LEBEDEV_MA.REGIONS r join LEBEDEV_MA.CITIES c on r.ID_REGION = C.ID_REGION where c.ID_REGION = v_id_region
        )
    loop
        DBMS_OUTPUT.PUT_LINE(i.Город);
    end loop;
end;