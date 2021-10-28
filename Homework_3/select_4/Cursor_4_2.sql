--Выдать всех врачей (неудаленных) конкретной больницы
-- отсортировать по квалификации: у кого есть выше, по участку: если участок совпадает с участком пациента, то такие выше
declare
    v_cursor_1 sys_refcursor;
    v_area varchar2(10);
    type record_1 is record (surname varchar2(100), name varchar2(100), gender varchar2(25), specName varchar2(100), qualification varchar2(30), salary varchar2(100), area varchar2(10));
    v_record_doctors record_1;
begin
    DBMS_OUTPUT.ENABLE();
    v_area := '2';
    open v_cursor_1 for select d.SURNAME as Фамилия, d.Name as Имя, g.Name as Гендер, s.NAME as Специальность, q.QUALIFICATION as Квалификация,
        d.SALARY as ЗП, d.AREA as Участок
        from LEBEDEV_MA.DOCTORS d join LEBEDEV_MA.SPECIALITY s on d.ID_SPECIALITY = s.ID_SPECIALITY join LEBEDEV_MA.GENDER g on d.ID_GENDER = g.ID_GENDER
        join LEBEDEV_MA.QUALIFICATION q on d.ID_QUALIFICATION = q.ID_QUALIFICATION where d.ID_HOSPITAL = 1 order by q.ID_QUALIFICATION,
        case when d.AREA = v_area then 1 else 0 end;

    loop
        fetch v_cursor_1 into v_record_doctors;
        exit when v_cursor_1%notfound;
        DBMS_OUTPUT.PUT_LINE(v_record_doctors.surname || ' ' || v_record_doctors.name || '; ' || v_record_doctors.gender || '; ' || v_record_doctors.specName || '; ' ||
                             v_record_doctors.qualification || '; ' || v_record_doctors.salary || '; ' || v_record_doctors.area);
    end loop;
    close v_cursor_1;
end;