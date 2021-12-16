--Тесты пациентов
create or replace package LEBEDEV_MA.test_pkg_patients
as
    --%suite
    --%rollback(manual)

    --%beforeall
    procedure seed_before_all;

    --%afterall
    procedure rollback_after_all;

    --%test(Тест на foreign_key id_gender)
    --%throws(-01400)
    procedure check_patient_id_gender_constraint;

    --%test(Тест на foreign_key id_account)
    --%throws(-01400)
    procedure check_patient_id_account_constraint;

    --%test(Тест на отсутствие в БД дат рождения позже текущей даты)
    procedure check_patient_no_future_birth;

    --%test(Тест на ограничение фамилии)
    --%throws(-01400)
    procedure check_patient_surname_constraint;

    --%test(Тест на ограничение имени)
    --%throws(-01400)
    procedure check_patient_name_constraint;
end;

create or replace package body LEBEDEV_MA.test_pkg_patients
as
    mock_id_patient number;
    mock_surname varchar2(100);
    mock_name varchar2(100);
    mock_patronymic varchar2(100);
    mock_date_of_birth date;
    mock_id_gender number;
    mock_phone_number varchar2(11);
    mock_area varchar2(10);
    mock_id_account number;

    procedure check_patient_id_gender_constraint
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
        insert into LEBEDEV_MA.PATIENTS(
            SURNAME,
            NAME,
            PATRONYMIC,
            DATEOFBIRTH,
            ID_GENDER,
            PHONENUMBER,
            AREA,
            ID_ACCOUNT
        )
        values (
            mock_surname,
            mock_name,
            mock_patronymic,
            mock_date_of_birth,
            null,
            mock_phone_number,
            mock_area,
            mock_id_account
        );
    end;

    procedure check_patient_id_account_constraint
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
       insert into LEBEDEV_MA.PATIENTS(
            SURNAME,
            NAME,
            PATRONYMIC,
            DATEOFBIRTH,
            ID_GENDER,
            PHONENUMBER,
            AREA,
            ID_ACCOUNT
        )
        values (
            mock_surname,
            mock_name,
            mock_patronymic,
            mock_date_of_birth,
            mock_id_gender,
            mock_phone_number,
            mock_area,
            null
        );
    end;

    procedure check_patient_no_future_birth
    as
        v_count number := 0;
    begin
        select count(*)
        into v_count
        from LEBEDEV_MA.PATIENTS pat
        where pat.DATEOFBIRTH > sysdate;
        TOOL_UT3.UT.EXPECT(v_count).TO_EQUAL(0);
    end;

    procedure check_patient_surname_constraint
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
        insert into LEBEDEV_MA.PATIENTS(
            SURNAME,
            NAME,
            PATRONYMIC,
            DATEOFBIRTH,
            ID_GENDER,
            PHONENUMBER,
            AREA,
            ID_ACCOUNT
        )
        values (
            null,
            mock_name,
            mock_patronymic,
            mock_date_of_birth,
            mock_id_gender,
            mock_phone_number,
            mock_area,
            mock_id_account
        );
    end;

    procedure check_patient_name_constraint
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
        insert into LEBEDEV_MA.PATIENTS(
            SURNAME,
            NAME,
            PATRONYMIC,
            DATEOFBIRTH,
            ID_GENDER,
            PHONENUMBER,
            AREA,
            ID_ACCOUNT
        )
        values (
            mock_surname,
            null,
            mock_patronymic,
            mock_date_of_birth,
            mock_id_gender,
            mock_phone_number,
            mock_area,
            mock_id_account
        );
    end;

    procedure seed_before_all
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));

        mock_surname := 'surname';
        mock_name := 'name';
        mock_patronymic := 'patronymic';
        mock_date_of_birth := to_date('30.06.2004 11:47', 'dd.mm.yyyy hh24:mi');
        mock_id_gender := 12;
        mock_phone_number := '88005553535';
        mock_area := '2';
        mock_id_account := 5;

        insert into LEBEDEV_MA.PATIENTS(
            SURNAME,
            NAME,
            PATRONYMIC,
            DATEOFBIRTH,
            ID_GENDER,
            PHONENUMBER,
            AREA,
            ID_ACCOUNT
        )
        values (
            mock_surname,
            mock_name,
            mock_patronymic,
            mock_date_of_birth,
            mock_id_gender,
            mock_phone_number,
            mock_area,
            mock_id_account
        )
        returning ID_PATIENT into mock_id_patient;
    end;

    procedure rollback_after_all
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
        rollback;
    end;
end;

--Запуск тестов на талоны
begin
    TOOL_UT3.UT.RUN('LEBEDEV_MA.test_pkg_patients');
end;