--Пакет для работы со специальностями
create or replace package LEBEDEV_MA.pkg_speciality
as
    --Получить курсор со всеми специальностями
    function get_cursor_all_speciality
        return sys_refcursor;

    --Получить курсор больниц конкретной специальности
    function get_cursor_hosp_by_spec_name(
        p_spec_name varchar2
    )
    return sys_refcursor;
end;

--Тело пакета
create or replace package body LEBEDEV_MA.pkg_speciality
as
    --Получить курсор со всеми специальностями
    function get_cursor_all_speciality
        return sys_refcursor
    as
        v_cursor sys_refcursor;
    begin
        open v_cursor for
            select
                   sp.NAME as Специальность
            from
                LEBEDEV_MA.HOSPITALS h
                join LEBEDEV_MA.DOCTORS d on d.ID_HOSPITAL = h.ID_HOSPITAL
                join LEBEDEV_MA.SPECIALITY sp on d.ID_SPECIALITY = sp.ID_SPECIALITY
            where
                  d.DELETED is null and
                  sp.DELETED is null and
                  h.DELETED is null
            group by
                     sp.NAME;
        return v_cursor;
    end;

    --Получить специальности конкретной больницы
    function get_cursor_hosp_by_spec_name(
        p_spec_name varchar2
    )
    return sys_refcursor
    as
        v_cursor sys_refcursor;
    begin
        open v_cursor for
            select
               h.ID_HOSPITAL as Айди_филиала,
               h.ISAVAILABLE as Доступность,
               tp.Name as Тип_больницы,
               count(d.Name) as Колво_врачей,
               mo.Name as Мед_Организация,
               sp.Name as Специальность
            from
                 LEBEDEV_MA.HOSPITALS h
                 join LEBEDEV_MA.MED_ORGANISATIONS mo on h.ID_MEDORGAN = mo.ID_MED_ORGANISATION
                 join LEBEDEV_MA.HOSPITAL_SPECIALITY hossp on h.ID_HOSPITAL = hossp.ID_HOSPITAL
                 join LEBEDEV_MA.SPECIALITY sp on hossp.ID_SPECIALITY = sp.ID_SPECIALITY
                 join LEBEDEV_MA.DOCTORS d on sp.ID_SPECIALITY = d.ID_SPECIALITY
                 join LEBEDEV_MA.TYPE tp on h.ID_TYPE = tp.ID_TYPE
            where
                  ((p_spec_name is not null and sp.NAME = p_spec_name)
                    or (sp.NAME is not null and p_spec_name is null))
            group by
                     h.ID_HOSPITAL,
                     h.ISAVAILABLE,
                     sp.Name,
                     mo.NAME,
                     h.ID_TYPE,
                     tp.Name
            order by
                     case when h.ID_TYPE = LEBEDEV_MA.PKG_CONSTANTS.C_HOSPITAL_PRIVATE_CONSTANT then 1 else 0 end,
                     Колво_врачей;
        return v_cursor;
    end;
end;