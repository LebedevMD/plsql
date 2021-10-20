declare
    v_name_city varchar2(100);
    v_id_city number;
    begin
    v_name_city := 'Санкт-Петербург';
    select c.ID_CITY into v_id_city from LEBEDEV_MA.CITIES c where c.NAME = v_name_city;
    DBMS_OUTPUT.PUT_LINE(v_id_city);
end;

--Заведите заранее переменные для участия в запросе. создайте запрос на получение чего-то where переменная