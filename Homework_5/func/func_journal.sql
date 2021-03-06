--Выдать журнал пациента

--Основная часть
declare
    v_cursor_journal sys_refcursor;
    type t_record_journal is
        record (
            Surname varchar2(100),
            ID_Talon number,
            Stat_Name varchar2(12));
    v_journal t_record_journal;
    v_pat_surname varchar2(100);
begin
    v_pat_surname := 'Логвенков';
    v_cursor_journal := LEBEDEV_MA.PKG_JOURNAL.GET_CURSOR_JOURNAL_BY_PATIENT_SURNAME(p_pat_surname => v_pat_surname);
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