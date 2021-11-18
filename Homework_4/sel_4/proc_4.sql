--Выдать всех врачей (неудаленных) конкретной больницы
-- отсортировать по квалификации: у кого есть выше, по участку: если участок совпадает с участком пациента, то такие выше

--Процедура
create or replace procedure LEBEDEV_MA.show_all_doctors_by_hospital(
    p_id_hospital number,
    p_area varchar2,
    out_cursor out sys_refcursor
)
as
begin
    open out_cursor for
        select
           d.SURNAME as Фамилия,
           d.Name as Имя,
           g.Name as Гендер,
           s.NAME as Специальность,
           q.QUALIFICATION as Квалификация,
           d.SALARY as ЗП,
           d.AREA as Участок
        from
             LEBEDEV_MA.DOCTORS d
             join LEBEDEV_MA.SPECIALITY s on d.ID_SPECIALITY = s.ID_SPECIALITY
             join LEBEDEV_MA.GENDER g on d.ID_GENDER = g.ID_GENDER
             join LEBEDEV_MA.QUALIFICATION q on d.ID_QUALIFICATION = q.ID_QUALIFICATION
        where
              ((p_id_hospital is not null and d.ID_HOSPITAL = p_id_hospital)
                  or (p_id_hospital is null and d.ID_HOSPITAL is not null ))
        order by
                 q.ID_QUALIFICATION,
                 case when d.AREA = p_area then 1 else 0 end;
end;

--Основная часть
declare
    v_cursor_doctors sys_refcursor;
    v_area varchar2(10);
    v_id_hospital number;
    type t_record_doc is
        record (
            surname varchar2(100),
            name varchar2(100),
            gender varchar2(25),
            specName varchar2(100),
            qualification varchar2(30),
            salary varchar2(100),
            area varchar2(10));
    v_doctors t_record_doc;
begin
    v_area := '2';
    select h.ID_Hospital into v_id_hospital from LEBEDEV_MA.HOSPITALS h where h.ADDRESS = 'Октябрьский проспект, 22';
    LEBEDEV_MA.show_all_doctors_by_hospital(p_id_hospital => v_id_hospital,
                                            p_area => v_area, out_cursor => v_cursor_doctors);
    fetch v_cursor_doctors into v_doctors;
    if v_cursor_doctors%found then
        loop
            DBMS_OUTPUT.PUT_LINE(v_doctors.surname || ' ' || v_doctors.name || '; ' ||
                                 v_doctors.gender || '; ' ||
                                 v_doctors.specName || '; ' ||
                                 v_doctors.qualification || '; ' ||
                                 v_doctors.salary || '; ' ||
                                 v_doctors.area);
            fetch v_cursor_doctors into v_doctors;
            exit when v_cursor_doctors%notfound;
        end loop;
    else
        DBMS_OUTPUT.PUT_LINE('Врачей в данной больнице не найдено');
    end if;
    close v_cursor_doctors;
end;
