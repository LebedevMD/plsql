--Выдать все документы

--Основная часть
declare
    v_cursor_documents sys_refcursor;
    v_surname varchar2(100);
    type t_record_docs is
        record(
            Surname varchar2(100),
            Name varchar2(100),
            DocName varchar2(15),
            DocValue varchar2(50));
    v_docs t_record_docs;
begin
    v_surname := 'Шиянов';
    v_cursor_documents := LEBEDEV_MA.PKG_PATIENTS.GET_CURSOR_DOCUMENTS_BY_SURNAME(p_surname => v_surname);
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