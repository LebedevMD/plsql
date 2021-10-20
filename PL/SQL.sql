declare
    v_string varchar2(100);
    v_number number;
begin
    DBMS_OUTPUT.ENABLE();
    select c.ID_REGION, c.ID_REGION into v_string, v_number from LEBEDEV_MA.CITIES c where c.NAME = 'Кемерово';
    dbms_output.put_line(v_string);
    dbms_output.put_line(v_number);
end;

--Сделайте выборку одного поля из таблицы. запишите результат в переменную: строковую и числовую
