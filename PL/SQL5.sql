declare
    v_string varchar2(100);
    begin
    select mo.NAME into v_string from LEBEDEV_MA.MED_ORGANISATIONS mo where ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE(v_string);
end;

--Заведите заранее переменную типа строки. создайте выборку забирающуюю ровну одну строку. выведите в консоль результат