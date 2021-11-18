--Талоны, работа с ними, с журналом
create or replace package LEBEDEV_MA.pkg_talon
as
    --Тип для талонов
    type t_record_talon is
        record (
            Name varchar2(100),
            StartDate date,
            EndDate date);

    --Запись
    procedure registration_for_the_talon(
        p_id_patient number,
        p_id_talon number
    );

    --Отмена записи
    procedure cancel_sign_up(
        p_id_talon number
    );

    --Функция с возвратом курсора с журналом пациента
    function get_cursor_journal_by_patient_surname(
        p_pat_surname varchar2
    )
    return sys_refcursor;

end;

--Тело пакета
create or replace package body LEBEDEV_MA.pkg_talon
as
    --Запись
    procedure registration_for_the_talon(
        p_id_patient number,
        p_id_talon number
    )
    as
    begin
        update LEBEDEV_MA.TALON tal set tal.ISOPEN = 0 where tal.ID_TALON = p_id_talon;
        insert into
            LEBEDEV_MA.JOURNAL jor (ID_PATIENT, ID_TALON, ID_STATUS)
        values
            (p_id_patient, p_id_talon, LEBEDEV_MA.PKG_CONSTANTS.C_JOURNAL_CONFIRMED_CONSTANT);
        commit;
    end;

    --Отмена записи
    procedure cancel_sign_up(
        p_id_talon number
    )
    as
    begin
        update LEBEDEV_MA.JOURNAL jr
        set jr.ID_STATUS = LEBEDEV_MA.PKG_CONSTANTS.C_JOURNAL_CANCELED_CONSTANT
        where jr.ID_TALON = p_id_talon;
        update LEBEDEV_MA.TALON tal
        set tal.ISOPEN = 1 where tal.ID_TALON = p_id_talon;
        commit;
    end;

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



