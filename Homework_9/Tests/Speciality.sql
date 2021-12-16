--Тесты специальностей
create or replace package LEBEDEV_MA.test_pkg_speciality
as
    --%suite
    --%rollback(manual)

    --%beforeall
    procedure seed_before_all;

    --%afterall
    procedure rollback_after_all;

    --%test(Тест на foreign_key id_age_required)
    --%throws(-01400)
    procedure check_speciality_id_age_required_constraint;

    --%test(Тест на ограничение наименования)
    --%throws(-01400)
    procedure check_speciality_name_constraint;

    --%test(Тест на foreign_key id_gender из таблицы required_gender)
    --%throws(-01400)
    procedure check_speciality_id_gender_constraint;

    --%test(Тест репозитория speciality, сериализация в специальности)
    procedure check_speciality_repository;

    --%test(Тест получения специальности по названию)
    procedure check_get_speciality_by_name;

    --%test(Тест провала получения специальности по названию)
    --%throws(no_data_found)
    procedure check_failed_get_speciality_by_name;

    --%test(Тест на отсутсвтие удалённых специальностей)
    procedure check_speciality_deleted;
end;

create or replace package body LEBEDEV_MA.test_pkg_speciality
as
    mock_id_speciality number;
    mock_name varchar2(50);
    mock_id_age_required number;
    mock_deleted date;

    procedure check_speciality_id_age_required_constraint
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
        insert into LEBEDEV_MA.SPECIALITY(
            NAME,
            ID_AGE_REQUIRED,
            DELETED
        )
        values (
            mock_name,
            null,
            mock_deleted
        );
    end;

    procedure check_speciality_name_constraint
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
       insert into LEBEDEV_MA.SPECIALITY(
            NAME,
            ID_AGE_REQUIRED,
            DELETED
        )
        values (
            null,
            mock_id_age_required,
            mock_deleted
        );
    end;


    procedure check_speciality_id_gender_constraint
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
       insert into LEBEDEV_MA.REQUIRED_GENDER(
            ID_SPECIALITY,
            ID_GENDER
            )
        VALUES (
            mock_id_speciality,
            null
        );
    end;

    procedure check_speciality_repository
    as
        v_code_num number;
        v_clob clob;
    begin
        v_clob := LEBEDEV_MA.REPOSITORY_SPECIALITY(v_code_num);
        TOOL_UT3.UT.EXPECT(v_code_num).TO_EQUAL(LEBEDEV_MA.pkg_code.c_ok);
    end;

    procedure check_get_speciality_by_name
    as
        v_item LEBEDEV_MA.T_SPECIALITY;
    begin
        select LEBEDEV_MA.T_SPECIALITY(
            name => sp.NAME,
            req_gender => (select g.NAME from LEBEDEV_MA.GENDER g where reqgen.ID_GENDER = g.ID_GENDER)
        )
        into v_item
        from LEBEDEV_MA.SPECIALITY sp
        join LEBEDEV_MA.REQUIRED_GENDER reqgen on sp.ID_SPECIALITY = reqgen.ID_SPECIALITY
        where sp.NAME = mock_name;
        TOOL_UT3.UT.EXPECT(v_item.name).TO_EQUAL(mock_name);
    end;

    procedure check_failed_get_speciality_by_name
    as
        v_item LEBEDEV_MA.T_SPECIALITY;
    begin
        select LEBEDEV_MA.T_SPECIALITY(
            name => sp.NAME,
            req_gender => (select g.NAME from LEBEDEV_MA.GENDER g where reqgen.ID_GENDER = g.ID_GENDER)
        )
        into v_item
        from LEBEDEV_MA.SPECIALITY sp
        join LEBEDEV_MA.REQUIRED_GENDER reqgen on sp.ID_SPECIALITY = reqgen.ID_SPECIALITY
        where sp.NAME = 'Костоправ';
        TOOL_UT3.UT.EXPECT(v_item.name).TO_EQUAL('Костоправ');
    end;

    procedure check_speciality_deleted
    as
        v_count number;
    begin
        select count(*)
        into v_count
        from LEBEDEV_MA.SPECIALITY spec
        where spec.DELETED is not null;
        TOOL_UT3.UT.EXPECT(v_count).TO_EQUAL(0);
    end;

    procedure seed_before_all
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));

        mock_name := 'Офтальмолог';
        mock_id_age_required := 4;
        mock_deleted := null;

        insert into LEBEDEV_MA.SPECIALITY(
            NAME,
            ID_AGE_REQUIRED,
            DELETED
        )
        values (
            mock_name,
            mock_id_age_required,
            mock_deleted
        )
        returning ID_SPECIALITY into mock_id_speciality;

        insert into LEBEDEV_MA.REQUIRED_GENDER(
            ID_SPECIALITY,
            ID_GENDER
            )
        VALUES (
            mock_id_speciality,
            12
        );
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
    TOOL_UT3.UT.RUN('LEBEDEV_MA.test_pkg_speciality');
end;