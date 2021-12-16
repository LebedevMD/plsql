--Тесты талонов
create or replace package LEBEDEV_MA.test_pkg_talon
as
    --%suite
    --%rollback(manual)

    --%beforeall
    procedure seed_before_all;

    --%afterall
    procedure rollback_after_all;

    --%test(Тест на foreign_key id_doctor)
    --%throws(-01400)
    procedure check_talon_id_doctor_constraint;

    --%test(Тест на ограничение начала талона)
    --%throws(-01400)
    procedure check_talon_start_date_constraint;

    --%test(Тест на ограничение конца талона)
    --%throws(-01400)
    procedure check_talon_end_date_constraint;

    --%test(Тест на успешную запись на талон)
    procedure check_talon_sign_up;

    --%test(Тест на провальную запись на талон)
    procedure check_talon_failed_sign_up;

    --%test(Тест на отмену записи на талон)
    procedure check_talon_cancel_sign_up;
end;


create or replace package body LEBEDEV_MA.test_pkg_talon
as
    mock_id_talon number;
    mock_id_doctor number;
    mock_isopen number;
    mock_start_date date;
    mock_end_date date;

    procedure check_talon_id_doctor_constraint
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
        insert into LEBEDEV_MA.TALON(
            ID_DOCTOR,
            ISOPEN,
            STARTDATE,
            ENDDATE
        )
        values (
            null,
            mock_isopen,
            mock_start_date,
            mock_end_date
        );
    end;

    procedure check_talon_start_date_constraint
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
       insert into LEBEDEV_MA.TALON(
            ID_DOCTOR,
            ISOPEN,
            STARTDATE,
            ENDDATE
        )
        values (
            mock_id_doctor,
            mock_isopen,
            null,
            mock_end_date
        );
    end;


    procedure check_talon_end_date_constraint
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
       insert into LEBEDEV_MA.TALON(
            ID_DOCTOR,
            ISOPEN,
            STARTDATE,
            ENDDATE
        )
        values (
            mock_id_doctor,
            mock_isopen,
            mock_start_date,
            null
        );
    end;

    procedure check_talon_sign_up
    as
        v_id_talon number;
        v_id_patient number;
        v_error_status number;
    begin
        select p.ID_Patient into v_id_patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Теплов';
        v_id_talon := 21;
        v_error_status := LEBEDEV_MA.sign_up_for_a_talon(p_id_talon => v_id_talon, p_id_patient => v_id_patient);
        TOOL_UT3.UT.EXPECT(v_error_status).TO_EQUAL(LEBEDEV_MA.PKG_CODE.C_OK);
    end;

    procedure check_talon_failed_sign_up
    as
        v_id_talon number;
        v_id_patient number;
        v_error_status number;
    begin
        select p.ID_Patient into v_id_patient from LEBEDEV_MA.PATIENTS p where p.SURNAME = 'Теплов';
        v_id_talon := 20;
        v_error_status := LEBEDEV_MA.sign_up_for_a_talon(p_id_talon => v_id_talon, p_id_patient => v_id_patient);
        TOOL_UT3.UT.EXPECT(v_error_status).TO_EQUAL(LEBEDEV_MA.PKG_CODE.C_ERROR);
    end;

    procedure check_talon_cancel_sign_up
    as
        v_id_talon number;
        v_error_status number;
    begin
        v_id_talon := 20;
        LEBEDEV_MA.cancel_sign_up_for_a_talon(p_id_talon => v_id_talon, p_error_status => v_error_status);
    end;

    procedure seed_before_all
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));

        mock_id_doctor := 7;
        mock_isopen := 1;
        mock_start_date := to_date('30.12.2021 16:00', 'dd.mm.yyyy hh24:mi');
        mock_end_date := to_date('30.12.2021 16:30', 'dd.mm.yyyy hh24:mi');

        insert into LEBEDEV_MA.TALON(
            ID_DOCTOR,
            ISOPEN,
            STARTDATE,
            ENDDATE
        )
        values (
            mock_id_doctor,
            mock_isopen,
            mock_start_date,
            mock_end_date
        )
        returning ID_TALON into mock_id_talon;
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
    TOOL_UT3.UT.RUN('LEBEDEV_MA.test_pkg_talon');
end;