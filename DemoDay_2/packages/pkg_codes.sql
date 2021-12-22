--Коды
create or replace package LEBEDEV_MA.pkg_codes
as
    c_ok constant integer := 0;
    c_error constant integer := -1;
    c_successful_registration constant integer := 100;
    c_already_recorded constant integer := 101;
    c_gender_incompatibility constant integer := 102;
    c_age_incompatibility constant integer := 103;
    c_talon_closed constant integer := 104;
    c_time_started constant integer := 105;
    c_doc_unavailable constant integer := 106;
    c_no_oms constant integer := 107;

    function Get_Message(
    p_code number
    )
    return varchar2;
end;

create or replace package body LEBEDEV_MA.pkg_codes
as
    function Get_Message(
    p_code number
    )
    return varchar2
    as
    begin
        case p_code
            when c_successful_registration then return 'Запись произведена успешно';
            when c_already_recorded  then return 'Пациент уже записан на этот талон';
            when c_gender_incompatibility  then return 'Пол пациента не совпадает с полом специальности';
            when c_age_incompatibility then return 'Возраст пациента не попадает в возрастной диапазон специальности';
            when c_talon_closed then return 'Талон закрыт для записи';
            when c_time_started then return 'Время талона уже начато, запись на него невозможна';
            when c_doc_unavailable then return 'Запись к данному доктору невозможна';
            when c_no_oms then return 'Нет полиса ОМС';
        end case;
    end;
end;