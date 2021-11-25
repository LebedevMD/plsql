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
            (p_id_patient, p_id_talon, LEBEDEV_MA.PKG_JOURNAL.C_JOURNAL_CONFIRMED);
        commit;
    end;

    --Отмена записи
    procedure cancel_sign_up(
        p_id_talon number
    )
    as
    begin
        update LEBEDEV_MA.JOURNAL jr
        set jr.ID_STATUS = LEBEDEV_MA.PKG_JOURNAL.C_JOURNAL_CANCELED
        where jr.ID_TALON = p_id_talon;
        update LEBEDEV_MA.TALON tal
        set tal.ISOPEN = 1 where tal.ID_TALON = p_id_talon;
        commit;
    end;
end;



