--Выдать журнал пациента

--Процедура
create or replace procedure LEBEDEV_MA.show_journal_by_patient_surname(
    p_pat_surname varchar2
)
as
    v_cursor_journal sys_refcursor;
    type t_record_journal is
        record (
            Surname varchar2(100),
            ID_Talon number,
            Stat_Name varchar2(12));
    v_journal t_record_journal;
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
    fetch v_cursor_journal into v_journal;
    if (v_cursor_journal%found) then
        loop
        DBMS_OUTPUT.put_line(v_journal.Surname ||
                             '; Талон № ' || v_journal.ID_Talon ||
                             '; Статус: ' || v_journal.Stat_Name);
        fetch v_cursor_journal into v_journal;
        exit when v_cursor_journal%notfound;
        end loop;
    else
        DBMS_OUTPUT.PUT_LINE('Записей в журнале для данного пациента не найдено');
    end if;
    close v_cursor_journal;
end;

--Основная часть
declare
    v_pat_surname varchar2(100);
begin
    v_pat_surname := 'Логвенков';
    LEBEDEV_MA.show_journal_by_patient_surname(p_pat_surname => v_pat_surname);
end;