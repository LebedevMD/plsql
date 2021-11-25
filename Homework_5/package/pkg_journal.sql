--Журнал
create or replace package LEBEDEV_MA.pkg_journal
as
    --ID статуса "Подтверждено" для журнала
    c_journal_confirmed constant number := 1;

    --ID статуса "Отменено" для журнала
    c_journal_canceled constant number := 2;

    --Функция с возвратом курсора с журналом пациента
    function get_cursor_journal_by_patient_surname(
        p_pat_surname varchar2
    )
    return sys_refcursor;
end;

create or replace package body LEBEDEV_MA.PKG_JOURNAL
as
    --Функция с возвратом курсора с журналом пациента
    function get_cursor_journal_by_patient_surname(
        p_pat_surname varchar2
    )
    return sys_refcursor
    as
        v_cursor_journal sys_refcursor;
        v_id_pat number;
    begin
        select p.ID_Patient into v_id_pat from LEBEDEV_MA.PATIENTS p where p.SURNAME = p_pat_surname;
        open v_cursor_journal for
            select
                   pat.SURNAME as Фамилия_пациента,
                   tal.ID_Talon as Айди_талона,
                   st.STATUS_NAME as Статус
            from
                 LEBEDEV_MA.PATIENTS pat
                 join LEBEDEV_MA.JOURNAL jr on pat.ID_PATIENT = jr.ID_PATIENT
                 join LEBEDEV_MA.TALON tal on jr.ID_TALON = tal.ID_TALON
                 join LEBEDEV_MA.STATUS st on jr.ID_STATUS = st.ID_STATUS
            where
                  ((v_id_pat is not null and jr.ID_PATIENT = v_id_pat)
                      or (v_id_pat is null and jr.ID_PATIENT is not null ));
        return v_cursor_journal;
    end;
end;