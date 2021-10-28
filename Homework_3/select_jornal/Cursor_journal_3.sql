--Выдать журнал пациента
declare
    v_id_pat number;
begin
    DBMS_OUTPUT.enable();
    select pat.ID_Patient into v_id_pat from LEBEDEV_MA.PATIENTS pat where pat.SURNAME = 'Логвенков';
    for i in (select pat.SURNAME as Фамилия_пациента, tal.ID_Talon as Айди_талона, st.STATUS_NAME as Статус
        from LEBEDEV_MA.PATIENTS pat join LEBEDEV_MA.JOURNAL jr on pat.ID_PATIENT = jr.ID_PATIENT join LEBEDEV_MA.TALON tal on jr.ID_TALON = tal.ID_TALON join
        LEBEDEV_MA.STATUS st on jr.ID_STATUS = st.ID_STATUS where jr.ID_PATIENT = v_id_pat)
    loop
        DBMS_OUTPUT.put_line(i.Фамилия_пациента || '; Талон № ' || i.Айди_талона || '; Статус: ' || i.Статус);
    end loop;
end;