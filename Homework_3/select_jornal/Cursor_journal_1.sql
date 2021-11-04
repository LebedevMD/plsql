--Выдать журнал пациента
declare
    cursor cursor_1(p_id_pat number) is
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
              ((p_id_pat is not null and jr.ID_PATIENT = p_id_pat)
                  or (p_id_pat is null and jr.ID_PATIENT is not null ));
    type record_1 is
        record (
            Surname varchar2(100),
            ID_Talon number,
            Stat_Name varchar2(12));
    v_record_journal record_1;
    v_id_pat number;
begin
    DBMS_OUTPUT.enable();
    select pat.ID_Patient into v_id_pat from LEBEDEV_MA.PATIENTS pat where pat.SURNAME = 'Логвенков';
    open cursor_1 (v_id_pat);
    loop
        fetch cursor_1 into v_record_journal;
        exit when cursor_1%notfound;
        DBMS_OUTPUT.put_line(v_record_journal.Surname ||
                             '; Талон № ' || v_record_journal.ID_Talon ||
                             '; Статус: ' || v_record_journal.Stat_Name);
    end loop;
    close cursor_1;
end;