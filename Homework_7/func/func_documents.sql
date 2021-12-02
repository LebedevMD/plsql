--Выдать все документы

--Основная часть
declare
    v_surname varchar2(100);
    v_id_patient number;
    v_arr_documents LEBEDEV_MA.T_ARR_DOCUMENTS;
begin
    v_surname := 'Шиянов';
    select pat.ID_Patient
    into v_id_patient
    from LEBEDEV_MA.PATIENTS pat
    where pat.SURNAME = v_surname;
    select LEBEDEV_MA.T_DOCUMENTS(
        name => doc.Name,
        value => DocNum.Value
   )
    bulk collect into v_arr_documents
    from
         LEBEDEV_MA.DOCUMENTS_NUMBERS DocNum
         join LEBEDEV_MA.DOCUMENT doc on DocNum.ID_DOCUMENT = doc.ID_DOCUMENT
         join LEBEDEV_MA.PATIENTS pat on DocNum.ID_PATIENT = pat.ID_PATIENT
    where
          pat.ID_PATIENT = v_id_patient;

    for i in v_arr_documents.first..v_arr_documents.LAST
    loop
        declare
            v_item LEBEDEV_MA.T_DOCUMENTS;
        begin
            v_item := v_arr_documents(i);
            DBMS_OUTPUT.put_line(v_item.Name || ': ' || v_item.value);
        end;
    end loop;
end;