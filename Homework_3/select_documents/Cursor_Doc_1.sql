--Выдать все документы
declare
    cursor cursor_1(p_id_pat number) is (select pat.Surname, pat.Name ,doc.Name, DocNum.Value
        from LEBEDEV_MA.DOCUMENTS_NUMBERS DocNum join LEBEDEV_MA.DOCUMENT doc on DocNum.ID_DOCUMENT = doc.ID_DOCUMENT join LEBEDEV_MA.PATIENTS pat on DocNum.ID_PATIENT = pat.ID_PATIENT
        where pat.ID_PATIENT = p_id_pat);
    type record_1 is record (Surname varchar2(100), Name varchar2(100), DocName varchar2(15), DocValue varchar2(50));
    v_record_docs record_1;
    v_id_pat number;
begin
    DBMS_OUTPUT.enable();
    select pat.ID_Patient into v_id_pat from LEBEDEV_MA.PATIENTS pat where pat.SURNAME = 'Останина';
    open cursor_1 (v_id_pat);
    loop
        fetch cursor_1 into v_record_docs;
        exit when cursor_1%notfound;
        DBMS_OUTPUT.PUT_LINE(v_record_docs.Surname || ' ' || v_record_docs.Name || '; ' || v_record_docs.DocName || ': ' || v_record_docs.DocValue);
    end loop;
    close cursor_1;
end;