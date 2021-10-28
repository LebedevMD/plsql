--Выдать все документы
declare
    v_id_pat number;
begin
    DBMS_OUTPUT.enable();
    select pat.ID_Patient into v_id_pat from LEBEDEV_MA.PATIENTS pat where pat.SURNAME = 'Теплов';
    for i in (select pat.Surname as Фамилия, pat.Name as Имя ,doc.Name as Название_документа, DocNum.Value as Знач_документа
        from LEBEDEV_MA.DOCUMENTS_NUMBERS DocNum join LEBEDEV_MA.DOCUMENT doc on DocNum.ID_DOCUMENT = doc.ID_DOCUMENT join LEBEDEV_MA.PATIENTS pat on DocNum.ID_PATIENT = pat.ID_PATIENT
        where pat.ID_PATIENT = v_id_pat)
    loop
        DBMS_OUTPUT.put_line(i.Фамилия || ' ' || i.Имя || '; ' || i.Название_документа || ': ' || i.Знач_документа);
    end loop;
end;