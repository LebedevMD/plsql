--*Выдать все больницы (неудаленные) конкретной специальности с пометками о доступности, кол-ве врачей;
--отсортировать по типу: частные выше, по кол-ву докторов: где больше выше
declare
    v_spec_name varchar2(50);
begin
    DBMS_OUTPUT.ENABLE();
    v_spec_name := 'Хирург';
    for i in (select h.ID_HOSPITAL as Айди_филиала, h.ISAVAILABLE as Доступность, count(d.Name) as Колво_врачей,
        mo.Name as Мед_Организация, sp.Name as Специальность
        from LEBEDEV_MA.HOSPITALS h join LEBEDEV_MA.MED_ORGANISATIONS mo on h.ID_MEDORGAN = mo.ID_MED_ORGANISATION join LEBEDEV_MA.HOSPITAL_SPECIALITY hossp on h.ID_HOSPITAL = hossp.ID_HOSPITAL
        join LEBEDEV_MA.SPECIALITY sp on hossp.ID_SPECIALITY = sp.ID_SPECIALITY join LEBEDEV_MA.DOCTORS d on sp.ID_SPECIALITY = d.ID_SPECIALITY
        where sp.NAME = v_spec_name group by h.ID_HOSPITAL, h.ISAVAILABLE, sp.Name, mo.NAME, h.ID_TYPE order by case when h.ID_HOSPITAL = 1 then 1 else 0 end)
    loop
        DBMS_OUTPUT.PUT_LINE('ID_Больницы: ' || i.Айди_филиала);
        DBMS_OUTPUT.PUT_LINE('Доступность: ' || i.Доступность);
        DBMS_OUTPUT.PUT_LINE('Кол-во докторов: ' || i.Колво_врачей);
        DBMS_OUTPUT.PUT_LINE('Название мед. организации: ' || i.Мед_Организация);
    end loop;
end;