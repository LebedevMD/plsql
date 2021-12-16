--Тесты больницы
create or replace package LEBEDEV_MA.test_pkg_hospital
as
    --%suite
    --%rollback(manual)

    --%beforeall
    procedure seed_before_all;

    --%afterall
    procedure rollback_after_all;

    --%test(Тест на foreign_key id_medorgan)
    --%throws(-01400)
    procedure check_hospital_id_medorgan_constraint;

    --%test(Тест на ограничение адреса)
    --%throws(-01400)
    procedure check_hospital_address_constraint;

    --%test(Тест на foreign_key id_type)
    --%throws(-01400)
    procedure check_hospital_id_type_constraint;

    --%test(Тест репозитория hospital, сериализация в больницу)
    procedure check_hospital_repository;

    --%test(Тест получения больницы по адресу)
    procedure check_get_hospital_by_address;

    --%test(Тест провала получения больницы по адресу)
    --%throws(no_data_found)
    procedure check_failed_get_hospital_by_address;

    --%test(Тест на отсутсвтие удалённых больниц)
    procedure check_hospital_deleted;
end;

create or replace package body LEBEDEV_MA.test_pkg_hospital
as
    mock_id_hospital number;
    mock_id_medorgan number;
    mock_isavailable number;
    mock_id_type number;
    mock_deleted date;
    mock_address varchar2(500);

    procedure check_hospital_id_medorgan_constraint
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
        insert into LEBEDEV_MA.HOSPITALS(
            ID_MEDORGAN,
            ISAVAILABLE,
            ID_TYPE,
            DELETED,
            ADDRESS
        )
        values (
            null,
            mock_isavailable,
            mock_id_type,
            mock_deleted,
            mock_address
        );
    end;

    procedure check_hospital_address_constraint
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
       insert into LEBEDEV_MA.HOSPITALS(
            ID_MEDORGAN,
            ISAVAILABLE,
            ID_TYPE,
            DELETED,
            ADDRESS
        )
        values (
            mock_id_medorgan,
            mock_isavailable,
            mock_id_type,
            mock_deleted,
            null
        );
    end;


    procedure check_hospital_id_type_constraint
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
       insert into LEBEDEV_MA.HOSPITALS(
            ID_MEDORGAN,
            ISAVAILABLE,
            ID_TYPE,
            DELETED,
            ADDRESS
        )
        values (
            mock_id_medorgan,
            mock_isavailable,
            null,
            mock_deleted,
            mock_address
        );
    end;

    procedure check_hospital_repository
    as
        v_code_num number;
        v_clob clob;
    begin
        v_clob := LEBEDEV_MA.REPOSITORY_HOSPITAL(v_code_num);
        TOOL_UT3.UT.EXPECT(v_code_num).TO_EQUAL(LEBEDEV_MA.pkg_code.c_ok);
    end;

    procedure check_get_hospital_by_address
    as
        v_item LEBEDEV_MA.T_HOSPITAL;
    begin
        select LEBEDEV_MA.T_HOSPITAL(
               med_organisation => (select name from LEBEDEV_MA.MED_ORGANISATIONS mo where mo.ID_MED_ORGANISATION = hosp.ID_MEDORGAN),
               ISAVAILABLE => hosp.ISAVAILABLE,
               type_name => (select name from LEBEDEV_MA.TYPE t where t.ID_TYPE = hosp.ID_TYPE),
               address => hosp.ADDRESS
        )
        into v_item
        from LEBEDEV_MA.HOSPITALS hosp
        where hosp.ID_HOSPITAL = mock_id_hospital;
        TOOL_UT3.UT.EXPECT(v_item.ADDRESS).TO_EQUAL(mock_address);
    end;

    procedure check_failed_get_hospital_by_address
    as
        v_item LEBEDEV_MA.T_HOSPITAL;
    begin
        select LEBEDEV_MA.T_HOSPITAL(
               med_organisation => (select name from LEBEDEV_MA.MED_ORGANISATIONS mo where mo.ID_MED_ORGANISATION = hosp.ID_MEDORGAN),
               ISAVAILABLE => hosp.ISAVAILABLE,
               type_name => (select name from LEBEDEV_MA.TYPE t where t.NAME = hosp.ID_TYPE),
               address => hosp.ADDRESS
        )
        into v_item
        from LEBEDEV_MA.HOSPITALS hosp
        where hosp.ADDRESS = 'У чёрта на куличках';
        TOOL_UT3.UT.EXPECT(v_item.ADDRESS).TO_EQUAL('У чёрта на куличках');
    end;

    procedure check_hospital_deleted
    as
        v_count number;
    begin
        select count(*)
        into v_count
        from LEBEDEV_MA.HOSPITALS hosp
        where hosp.DELETED is not null;
        TOOL_UT3.UT.EXPECT(v_count).TO_EQUAL(0);
    end;

    procedure seed_before_all
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));

        mock_id_medorgan := 1;
        mock_isavailable := 1;
        mock_id_type := 1;
        mock_deleted := null;
        mock_address := 'Тридевятое царство';

        insert into LEBEDEV_MA.HOSPITALS(
            ID_MEDORGAN,
            ISAVAILABLE,
            ID_TYPE,
            DELETED,
            ADDRESS
        )
        values (
            mock_id_medorgan,
            mock_isavailable,
            mock_id_type,
            mock_deleted,
            mock_address
        )
        returning ID_HOSPITAL into mock_id_hospital;
    end;

    procedure rollback_after_all
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
        rollback;
    end;
end;

--Запуск тестов на больницы
begin
    TOOL_UT3.UT.RUN('LEBEDEV_MA.test_pkg_hospital');
end;