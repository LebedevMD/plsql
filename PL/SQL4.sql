declare
    type my_record is record (ID_CITY number, NAME nvarchar2(100));
    type arr_type is table of my_record
    index by binary_integer;
    v_cities arr_type;
    begin
    for i in (select c.ID_CITY, c.NAME from LEBEDEV_MA.CITIES c)
    loop
        v_cities(i.ID_CITY).ID_CITY := i.ID_CITY;
        v_cities(i.ID_CITY).NAME := i.NAME;
    end loop;

    for i in v_cities.first..v_cities.LAST
    loop
        DBMS_OUTPUT.PUT_LINE(v_cities(i).NAME);
    end loop;
end;

--Завести заранее переменную массива строк. сделать выборку на массив строк. записать в переменную. вывести каждую строку в цикле в консоль