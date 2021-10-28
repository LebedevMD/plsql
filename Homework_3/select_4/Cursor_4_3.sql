--Выдать всех врачей (неудаленных) конкретной больницы
-- отсортировать по квалификации: у кого есть выше, по участку: если участок совпадает с участком пациента, то такие выше
declare
    v_area varchar2(10);
begin
    v_area := '2';
    for i in (select d.SURNAME as Фамилия, d.Name as Имя, g.Name as Гендер, s.NAME as Специальность, q.QUALIFICATION as Квалификация,
        d.SALARY as ЗП, d.AREA as Участок
        from LEBEDEV_MA.DOCTORS d join LEBEDEV_MA.SPECIALITY s on d.ID_SPECIALITY = s.ID_SPECIALITY join LEBEDEV_MA.GENDER g on d.ID_GENDER = g.ID_GENDER
        join LEBEDEV_MA.QUALIFICATION q on d.ID_QUALIFICATION = q.ID_QUALIFICATION where d.ID_HOSPITAL = 1 order by q.ID_QUALIFICATION,
        case when d.AREA = v_area then 1 else 0 end)
    loop
    DBMS_OUTPUT.PUT_LINE(i.Фамилия || ' ' || i.Имя || '; ' || i.Гендер || '; ' || i.Специальность || '; ' ||
                             i.Квалификация || '; ' || i.ЗП || '; ' || i.Участок);
    end loop;
end;


