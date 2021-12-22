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

    --%test(Тест сериализации в доктора)
    procedure check_doctor_merge;

    --%test(Тест получения доктора по ID)
    procedure check_get_doctor_by_ID;

    --%test(Тест провала получения доктора по ID)
    procedure check_failed_get_doctor_by_ID;
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

    procedure check_doctor_merge
    as
        e_error exception;
        v_clob clob;
        v_result number;
        v_arr_doctors LEBEDEV_MA.t_arr_doctors_dto;
        pragma exception_init (e_error, -20001);
    begin
        v_clob := LEBEDEV_MA.REPOSITORY_DOCTOR.GET_FROM_ANOTHER_SYSTEM(v_result);
        if (v_result != LEBEDEV_MA.PKG_CODES.C_ERROR) then
            v_arr_doctors := LEBEDEV_MA.REPOSITORY_DOCTOR.DESERIALIZATION(v_clob, v_result);
        end if;
        if (v_arr_doctors.COUNT = 0) then v_result := LEBEDEV_MA.PKG_CODES.C_ERROR; end if;
        if (v_result != LEBEDEV_MA.PKG_CODES.C_ERROR) then
            LEBEDEV_MA.REPOSITORY_DOCTOR.MERGE(v_arr_doctors, v_result);
        end if;

        if (v_result = LEBEDEV_MA.PKG_CODES.C_ERROR) then
             raise_application_error(20001, 'Произошла какая-то ошибка');
        end if;
    end;

    procedure check_get_doctor_by_ID
    as
        v_item LEBEDEV_MA.T_DOCTORS;
    begin
        v_item := LEBEDEV_MA.PKG_DOCTORS.GET_DOCTOR_BY_ID(mock_id_doctor);
        TOOL_UT3.UT.EXPECT(v_item.SURNAME).TO_EQUAL(mock_surname);
    end;

    procedure check_failed_get_doctor_by_ID
    as
        v_item LEBEDEV_MA.T_DOCTORS;
    begin
         v_item := LEBEDEV_MA.PKG_DOCTORS.GET_DOCTOR_BY_ID(1);
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