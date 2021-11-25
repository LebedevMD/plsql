--Пакет для работы с докторами
create or replace package LEBEDEV_MA.pkg_doctors
as
    --Тип доктора
    type t_record_doc is
        record (
            surname varchar2(100),
            name varchar2(100),
            gender varchar2(25),
            specName varchar2(100),
            qualification varchar2(30),
            salary varchar2(100),
            area varchar2(10));

    --Курсор для получения талонов доктора по его ID
    cursor v_cursor_talon(
        p_id_doc number
        )
        return LEBEDEV_MA.PKG_TALON.T_RECORD_TALON;
end;

--Тело пакета
create or replace package body LEBEDEV_MA.pkg_doctors
as
    --Курсор для получения талонов доктора по его ID
    cursor v_cursor_talon(
        p_id_doc number
        )
        return LEBEDEV_MA.PKG_TALON.T_RECORD_TALON
        is
        select
               d.Name as Доктор,
               t.STARTDATE as Начало,
               t.ENDDATE as Конец
        from
             LEBEDEV_MA.DOCTORS d
             join LEBEDEV_MA.TALON t on d.ID_DOCTOR = t.ID_DOCTOR
        where
              (t.STARTDATE >= sysdate and
                ((p_id_doc is not null and d.ID_DOCTOR = p_id_doc)
                or (p_id_doc is null)));
end;