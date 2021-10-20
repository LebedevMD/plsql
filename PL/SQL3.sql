declare
    v_is_condition boolean;
    v_string varchar2(100);
    begin
v_is_condition := false;
if (v_is_condition is not null and v_is_condition = true) then
    select r.NAME into v_string from LEBEDEV_MA.REGIONS r where r.ID_REGION = (select r.ID_REGION from LEBEDEV_MA.REGIONS r where r.NAME = 'Республика Татарстан');
else
    select c.NAME into v_string from LEBEDEV_MA.CITIES c where c.ID_CITY = (select c.ID_CITY from LEBEDEV_MA.CITIES c where c.NAME = 'Казань');
end if;
DBMS_OUTPUT.PUT_LINE(v_string);

case
    when v_is_condition = false then
        select mo.NAME into v_string from LEBEDEV_MA.MED_ORGANISATIONS mo where mo.ID_CITY = (select c.ID_CITY from LEBEDEV_MA.CITIES c where c.NAME = 'Кемерово') and ROWNUM = 1;
    else
        select mo.NAME into v_string from LEBEDEV_MA.MED_ORGANISATIONS mo where mo.ID_CITY = (select c.ID_CITY from LEBEDEV_MA.CITIES c where c.NAME = 'Санкт-Петербург') and ROWNUM = 1;
    end case;
DBMS_OUTPUT.PUT_LINE(v_string);

while v_is_condition
loop
    select r.NAME into v_string from LEBEDEV_MA.REGIONS r where ROWNUM = 1;
    DBMS_OUTPUT.PUT_LINE(v_string);
    v_is_condition := false;
    end loop;
end;

--Заведите булеву переменную. создайте запрос который имеет разный результат в зависимости от бул переменной. всеми известными способами
