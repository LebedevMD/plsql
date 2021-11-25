--Пакет для работы с пациентами
create or replace package LEBEDEV_MA.pkg_patients
as
    --Получить доки пациента по его фамилии
    function get_cursor_documents_by_surname(
        p_surname varchar2
    )
    return sys_refcursor;
end;

--Тело пакета
create or replace package body LEBEDEV_MA.pkg_patients
as
    --Получить доки пациента по его фамилии
    function get_cursor_documents_by_surname(
        p_surname varchar2
    )
    return sys_refcursor
    as
        v_cursor_documents sys_refcursor;
        v_id_patient number;
    begin
        select pat.ID_Patient
        into v_id_patient
        from LEBEDEV_MA.PATIENTS pat
        where pat.SURNAME = p_surname;
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
        return v_cursor_documents;
    exception
        when NO_DATA_FOUND then
        LEBEDEV_MA.ADD_ERROR_LOG('get_cursor_documents_by_surname',
                '{"error":"' || sqlerrm
                ||'","value":"' || p_surname
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}');
    end;
end;