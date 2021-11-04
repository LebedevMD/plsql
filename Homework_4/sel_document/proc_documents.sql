--Выдать все документы

--Процедура
create or replace procedure LEBEDEV_MA.show_all_documents_by_patient_surname(
    p_name varchar2
)
as
    v_cursor_documents sys_refcursor;
    v_id_patient number;
    type t_record_docs is
        record(
            Surname varchar2(100),
            Name varchar2(100),
            DocName varchar2(15),
            DocValue varchar2(50));
    v_docs t_record_docs;
begin
    select
           pat.ID_Patient
    into
        v_id_patient
    from
         LEBEDEV_MA.PATIENTS pat
    where
          pat.SURNAME = p_name;
    open v_cursor_documents for
        select
               pat.Surname,
               pat.Name,
               doc.Name,
               DocNum.Value
        from
             LEBEDEV_MA.DOCUMENTS_NUMBERS DocNum
             join LEBEDEV_MA.DOCUMENT doc on DocNum.ID_DOCUMENT = doc.ID_DOCUMENT
             join LEBEDEV_MA.PATIENTS pat on DocNum.ID_PATIENT = pat.ID_PATIENT
        where
              pat.ID_PATIENT = v_id_patient;
    fetch v_cursor_documents into v_docs;
    if (v_cursor_documents%found) then
        loop
            DBMS_OUTPUT.put_line(v_docs.Surname || ' ' || v_docs.Name || '; ' || v_docs.DocName || ': ' || v_docs.DocValue);
            fetch v_cursor_documents into v_docs;
            exit when v_cursor_documents%notfound;
        end loop;
    else
        DBMS_OUTPUT.PUT_LINE('Документов у данного пациента не найдено');
    end if;
    close v_cursor_documents;
end;

--Основная часть
declare
    v_surname varchar2(100);
begin
    v_surname := 'Пономарёва';
    LEBEDEV_MA.show_all_documents_by_patient_surname(p_name => v_surname);
end;