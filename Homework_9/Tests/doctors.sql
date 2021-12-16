--Тесты на доктора
create or replace package LEBEDEV_MA.test_pkg_doctor
as
    --%suite
    --%rollback(manual)

    --%beforeall
    procedure seed_before_all;

    --%afterall
    procedure rollback_after_all;

    --%test(Тест на foreign_key id_gender)
    --%throws(-01400)
    procedure check_doctor_id_gender_constraint;

    --%test(Тест на foreign_key id_speciality)
    --%throws(-01400)
    procedure check_doctor_id_speciality_constraint;

    --%test(Тест на foreign_key id_qualification)
    --%throws(-01400)
    procedure check_doctor_id_qualification_constraint;

    --%test(Тест репозитория doctor, сериализация в доктора)
    procedure check_doctor_repository;

    --%test(Тест получения доктора по ID)
    procedure check_get_doctor_by_ID;

    --%test(Тест провала получения доктора по ID)
    --%throws(no_data_found)
    procedure check_failed_get_doctor_by_ID;

    --%test(Проверка на отсутствие удалённых докторов)
    procedure check_doctor_deleted;
end;

create or replace package body LEBEDEV_MA.test_pkg_doctor
as
    mock_id_doctor number;
    mock_id_hospital number;
    mock_surname varchar2(100);
    mock_name varchar2(100);
    mock_patronymic varchar2(100);
    mock_id_gender number;
    mock_id_speciality number;
    mock_id_qualification number;
    mock_salary number;
    mock_area varchar2(10);
    mock_rating number;
    mock_deleted date;

    procedure check_doctor_id_gender_constraint
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
        insert into LEBEDEV_MA.DOCTORS (
            ID_HOSPITAL,
            SURNAME,
            NAME,
            PATRONYMIC,
            ID_GENDER,
            ID_SPECIALITY,
            ID_QUALIFICATION,
            SALARY,
            AREA,
            RATING
        )
        values (
            mock_id_hospital,
            mock_surname,
            mock_name,
            mock_patronymic,
            null,
            mock_id_speciality,
            mock_id_qualification,
            mock_salary,
            mock_area,
            mock_rating
        );
    end;

    procedure check_doctor_id_speciality_constraint
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
        insert into LEBEDEV_MA.DOCTORS (
            ID_HOSPITAL,
            SURNAME,
            NAME,
            PATRONYMIC,
            ID_GENDER,
            ID_SPECIALITY,
            ID_QUALIFICATION,
            SALARY,
            AREA,
            RATING
        )
        values (
            mock_id_hospital,
            mock_surname,
            mock_name,
            mock_patronymic,
            mock_id_gender,
            null,
            mock_id_qualification,
            mock_salary,
            mock_area,
            mock_rating
        );
    end;


    procedure check_doctor_id_qualification_constraint
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
        insert into LEBEDEV_MA.DOCTORS (
            ID_HOSPITAL,
            SURNAME,
            NAME,
            PATRONYMIC,
            ID_GENDER,
            ID_SPECIALITY,
            ID_QUALIFICATION,
            SALARY,
            AREA,
            RATING
        )
        values (
            mock_id_hospital,
            mock_surname,
            mock_name,
            mock_patronymic,
            mock_id_gender,
            mock_id_speciality,
            null,
            mock_salary,
            mock_area,
            mock_rating
        );
    end;

    procedure check_doctor_repository
    as
        v_code_num number;
        v_clob clob;
    begin
        v_clob := LEBEDEV_MA.REPOSITORY_DOCTORS(v_code_num);
        TOOL_UT3.UT.EXPECT(v_code_num).TO_EQUAL(LEBEDEV_MA.pkg_code.c_ok);
    end;

    procedure check_get_doctor_by_ID
    as
        v_item LEBEDEV_MA.T_DOKTOR;
    begin
        select LEBEDEV_MA.T_DOKTOR(
            ID_DOCTOR => doc.ID_DOCTOR,
            ID_HOSPITAL => doc.ID_HOSPITAL,
            SURNAME => doc.SURNAME,
            NAME => doc.NAME,
            PATRONYMIC => doc.PATRONYMIC)
        into v_item
        from LEBEDEV_MA.DOCTORS doc
        where doc.ID_DOCTOR = mock_id_doctor;
        TOOL_UT3.UT.EXPECT(v_item.ID_DOCTOR).TO_EQUAL(mock_id_doctor);
    end;

    procedure check_failed_get_doctor_by_ID
    as
        v_item LEBEDEV_MA.T_DOKTOR;
    begin
        select LEBEDEV_MA.T_DOKTOR(
            ID_DOCTOR => doc.ID_DOCTOR,
            ID_HOSPITAL => doc.ID_HOSPITAL,
            SURNAME => doc.SURNAME,
            NAME => doc.NAME,
            PATRONYMIC => doc.PATRONYMIC)
        into v_item
        from LEBEDEV_MA.DOCTORS doc
        where doc.ID_DOCTOR = 1;
        TOOL_UT3.UT.EXPECT(v_item.ID_DOCTOR).TO_EQUAL(1);
    end;

    procedure check_doctor_deleted
    as
        v_count number;
    begin
        select count(*)
        into v_count
        from LEBEDEV_MA.DOCTORS doc
        where doc.DELETED is not null;
        TOOL_UT3.UT.EXPECT(v_count).TO_EQUAL(0);
    end;

    procedure seed_before_all
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));

        mock_id_hospital := 1;
        mock_surname := 'surname';
        mock_name := 'name';
        mock_patronymic := 'patronymic';
        mock_id_gender := 10;
        mock_id_speciality := 5;
        mock_id_qualification := 10;
        mock_salary := 40000;
        mock_area := 3;
        mock_rating := 5;
        mock_deleted := null;

        insert into LEBEDEV_MA.DOCTORS(
            ID_HOSPITAL,
            SURNAME,
            NAME,
            PATRONYMIC,
            ID_GENDER,
            ID_SPECIALITY,
            ID_QUALIFICATION,
            SALARY,
            AREA,
            DELETED,
            RATING
        )
        values (
            mock_id_hospital,
            mock_surname,
            mock_name,
            mock_patronymic,
            mock_id_gender,
            mock_id_speciality,
            mock_id_qualification,
            mock_salary,
            mock_area,
            mock_deleted,
            mock_rating
        )
        returning ID_DOCTOR into mock_id_doctor;
    end;

    procedure rollback_after_all
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
        rollback;
    end;
end;

--Запуск тестов на доктора
begin
    TOOL_UT3.UT.RUN('LEBEDEV_MA.test_pkg_doctor');
end;