declare
    v_doctor LEBEDEV_MA.DOCTORS%rowtype;
    begin
    select * into v_doctor from LEBEDEV_MA.DOCTORS d where d.SALARY = 30000;
    DBMS_OUTPUT.PUT_LINE(v_doctor.SURNAME || ' ' || v_doctor.NAME);
end;

--Заведите заранее переменную типа строки. создайте выборку забирающуюю ровну одну строку. выведите в консоль результат