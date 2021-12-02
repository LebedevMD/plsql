--Выдать журнал пациента

--Основная часть
declare
    v_arr_journal LEBEDEV_MA.T_ARR_JOURNAL_TALON;
    v_id_pat number;
    v_pat_surname varchar2(100);
begin
    v_pat_surname := 'Логвенков';
    select p.ID_Patient into v_id_pat from LEBEDEV_MA.PATIENTS p where p.SURNAME = v_pat_surname;
    select LEBEDEV_MA.T_JOURNAL_TALON(
           ID_PATIENT => pat.ID_PATIENT,
           ID_TALON => tal.ID_Talon,
           status => st.STATUS_NAME
   )
    bulk collect into v_arr_journal
    from
         LEBEDEV_MA.PATIENTS pat
         join LEBEDEV_MA.JOURNAL jr on pat.ID_PATIENT = jr.ID_PATIENT
         join LEBEDEV_MA.TALON tal on jr.ID_TALON = tal.ID_TALON
         join LEBEDEV_MA.STATUS st on jr.ID_STATUS = st.ID_STATUS
    where
          ((v_id_pat is not null and jr.ID_PATIENT = v_id_pat)
              or (v_id_pat is null and jr.ID_PATIENT is not null ));
    for i in v_arr_journal.first..v_arr_journal.LAST
    loop
        declare
            v_item LEBEDEV_MA.T_JOURNAL_TALON;
        begin
            v_item := v_arr_journal(i);
            DBMS_OUTPUT.put_line(v_item.ID_PATIENT ||
                             '; Талон № ' || v_item.ID_Talon ||
                             '; Статус: ' || v_item.status);
        end;
    end loop;
end;