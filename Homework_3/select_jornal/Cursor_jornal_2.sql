--Выдать журнал пациента
declare
    v_cursor_1 sys_refcursor;
    type record_1 is record (Surname varchar2(100), ID_Talon number, Stat_Name varchar2(12));
    v_record_journal record_1;
    v_id_pat number;
begin
    DBMS_OUTPUT.enable();
    select pat.ID_Patient into v_id_pat from LEBEDEV_MA.PATIENTS pat where pat.SURNAME = 'Логвенков';
    open v_cursor_1 for select pat.SURNAME as Фамилия_пациента, tal.ID_Talon as Айди_талона, st.STATUS_NAME as Статус
        from LEBEDEV_MA.PATIENTS pat join LEBEDEV_MA.JOURNAL jr on pat.ID_PATIENT = jr.ID_PATIENT join LEBEDEV_MA.TALON tal on jr.ID_TALON = tal.ID_TALON join
        LEBEDEV_MA.STATUS st on jr.ID_STATUS = st.ID_STATUS where jr.ID_PATIENT = v_id_pat;
    loop
        fetch v_cursor_1 into v_record_journal;
        exit when v_cursor_1%notfound;
        DBMS_OUTPUT.put_line(v_record_journal.Surname || '; Талон № ' || v_record_journal.ID_Talon || '; Статус: ' || v_record_journal.Stat_Name);
    end loop;
    close v_cursor_1;
end;