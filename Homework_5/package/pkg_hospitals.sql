--Пакет для работы с больницами
create or replace package LEBEDEV_MA.pkg_hospitals
as
    --Курсор расписаний всех больниц
    cursor v_cursor_hospitals_schedule is
        select
               mo.Name,
               h.ID_Hospital,
               sch.DayOfWeek,
               sch.START_WORK,
               sch.END_WORK
            from
                 LEBEDEV_MA.SCHEDULE sch
                 join LEBEDEV_MA.HOSPITALS h on sch.ID_HOSPITAL = h.ID_HOSPITAL
                 join LEBEDEV_MA.MED_ORGANISATIONS mo on h.ID_MEDORGAN = mo.ID_MED_ORGANISATION;

    --Вывод всех врачей по ID больницы
    procedure show_doctors_by_id_hospital(
        p_id_hospital number,
        p_area varchar2
    );

    --Вывод всех врачей по ID больницы (перегрузка: без участка)
    procedure show_doctors_by_id_hospital(
        p_id_hospital number
    );
end;

--Тело пакета
create or replace package body LEBEDEV_MA.pkg_hospitals
as
    procedure show_doctors_by_id_hospital(
        p_id_hospital number,
        p_area varchar2
    )
    is
        v_cursor_doctors sys_refcursor;
        v_doctors LEBEDEV_MA.PKG_DOCTORS.T_RECORD_DOC;
    begin
        open v_cursor_doctors for
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

    --Вывод всех врачей по ID больницы (перегрузка: без участка)
    procedure show_doctors_by_id_hospital(
        p_id_hospital number
    )
    is
        v_cursor_doctors sys_refcursor;
        v_doctors LEBEDEV_MA.PKG_DOCTORS.T_RECORD_DOC;
    begin
        open v_cursor_doctors for
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
                     q.ID_QUALIFICATION;
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
end;