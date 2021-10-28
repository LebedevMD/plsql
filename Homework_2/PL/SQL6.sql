declare
    v_date_1 date;
    v_date_2 date;
    v_date_3 date;
    v_count number;
    begin
    v_date_1 := sysdate;
    v_date_2 := v_date_1 - 7;
    select count(*) into v_count from LEBEDEV_MA.TALON t where trunc(t.STARTDATE) = trunc(v_date_1);
    DBMS_OUTPUT.PUT_LINE('Талонов на '|| v_date_1 || ': ' ||v_count);
    select count(*) into v_count from LEBEDEV_MA.TALON t where trunc(t.STARTDATE) = trunc(v_date_2);
    DBMS_OUTPUT.PUT_LINE('Талонов на '|| v_date_2 || ': ' ||v_count);
    v_date_3 := to_date('20.10.2021', 'dd.mm.yyyy');
    select count(*) into v_count from LEBEDEV_MA.TALON t where trunc(t.STARTDATE) = trunc(v_date_3);
    DBMS_OUTPUT.PUT_LINE('Талонов на '|| v_date_3 || ': ' ||v_count);
    v_date_2 := v_date_3 - 7;
    select count(*) into v_count from LEBEDEV_MA.TALON t where trunc(t.STARTDATE) = trunc(v_date_2);
    DBMS_OUTPUT.PUT_LINE('Талонов на '|| v_date_2 || ': ' ||v_count);
end;

--Заведите заранее переменные даты. создайте выборку между датами: за сегодня, в день за неделю назад. сделайте тоже самое но через преобразрование даты из строки