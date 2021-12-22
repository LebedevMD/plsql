--Пакет доктора
create or replace package LEBEDEV_MA.pkg_doctors
as
    --Добавить доктора из внешней системы
    procedure add_doctor_extern(
        p_item LEBEDEV_MA.T_DOCTOR_DTO
    );

    --Добавить доктора
    procedure add_doctor(
        p_id_hospital number,
        p_surname varchar2,
        p_name varchar2,
        p_patronymic varchar2,
        p_id_gender number,
        p_id_speciality number,
        p_id_qualification number,
        p_salary number,
        p_area varchar2,
        p_rating number default 0,
        p_id_extern_sys number
    );

    --Удалить доктора по ID
    procedure delete_doctor_by_id(
        p_id number
    );

    --Получить талоны доктора по его id
    function get_doctor_talon_by_id(
        p_id number
    ) return LEBEDEV_MA.t_arr_talons;

    --Получить доктора по id
    function get_doctor_by_id(
        p_id number
    ) return LEBEDEV_MA.T_DOCTORS;

    --Получить доктора по id внешней системы
    function get_doctor_by_extern_id(
        p_id number
    ) return LEBEDEV_MA.T_DOCTORS;
end;

create or replace package body LEBEDEV_MA.PKG_DOCTORS
as
    procedure add_doctor_extern(
        p_item LEBEDEV_MA.T_DOCTOR_DTO
    ) as
    begin
        insert into LEBEDEV_MA.DOCTORS
        (
            ID_HOSPITAL,
             SURNAME,
             NAME,
             PATRONYMIC,
             ID_GENDER,
             ID_SPECIALITY,
             ID_QUALIFICATION,
             SALARY,
             AREA,
             RATING,
             ID_EXTERN_SYS
        )
        values
        (
            p_item.ID_HOSPITAL,
            p_item.SURNAME,
            p_item.NAME,
            p_item.PATRONYMIC,
            10,
            4,
            10,
            30000,
            2,
            4,
            p_item.ID_DOCTOR
        );
    end;

    procedure add_doctor(
        p_id_hospital number,
        p_surname varchar2,
        p_name varchar2,
        p_patronymic varchar2,
        p_id_gender number,
        p_id_speciality number,
        p_id_qualification number,
        p_salary number,
        p_area varchar2,
        p_rating number default 0,
        p_id_extern_sys number
    )
    as
    begin
        insert into LEBEDEV_MA.DOCTORS
        (
             ID_HOSPITAL,
             SURNAME,
             NAME,
             PATRONYMIC,
             ID_GENDER,
             ID_SPECIALITY,
             ID_QUALIFICATION,
             SALARY,
             AREA,
             RATING,
             ID_EXTERN_SYS
        )
        values
        (
            p_id_hospital,
            p_surname,
            p_name,
            p_patronymic,
            p_id_gender,
            p_id_speciality,
            p_id_qualification,
            p_salary,
            p_area,
            p_rating,
            p_id_extern_sys
        );
        commit;
    end;

    procedure delete_doctor_by_id(
        p_id number
    )
    as
    begin
        delete from LEBEDEV_MA.DOCTORS doc
        where doc.ID_DOCTOR = p_id;
        commit;
    exception
        when no_data_found then
            DBMS_OUTPUT.PUT_LINE('Такого доктора не существует');
    end;

    function get_doctor_talon_by_id(
        p_id number
    ) return LEBEDEV_MA.t_arr_talons
    as
        v_item LEBEDEV_MA.t_arr_talons := LEBEDEV_MA.t_arr_talons();
    begin
        select LEBEDEV_MA.T_TALON(
            id_doctor => tal.ID_DOCTOR,
            startDate => tal.STARTDATE,
            endDate => tal.ENDDATE,
            isOpen => tal.ISOPEN
        ) bulk collect into v_item
        from LEBEDEV_MA.TALON tal
        where tal.ID_DOCTOR = p_id;
        return v_item;
    exception
        when no_data_found then
            DBMS_OUTPUT.PUT_LINE('Такого доктора не существует');
        return v_item;
    end;

    function get_doctor_by_id(
        p_id number
    ) return LEBEDEV_MA.T_DOCTORS
    as
        v_item LEBEDEV_MA.T_DOCTORS;
    begin
        select LEBEDEV_MA.T_DOCTORS(
            surname => doc.SURNAME,
            name => doc.NAME,
            patronymic => doc.PATRONYMIC,
            gender => gen.NAME,
            spec_name => spec.NAME,
            salary => doc.SALARY,
            area => doc.AREA,
            rating => doc.RATING,
            id_extern_sys => doc.ID_EXTERN_SYS
        ) into v_item
        from LEBEDEV_MA.DOCTORS doc
            join LEBEDEV_MA.GENDER gen on doc.ID_GENDER = gen.ID_GENDER
            join LEBEDEV_MA.SPECIALITY spec on doc.ID_SPECIALITY = spec.ID_SPECIALITY
        where doc.ID_DOCTOR = p_id;
        return v_item;
    exception
        when no_data_found then
            DBMS_OUTPUT.PUT_LINE('Такого доктора не существует');
        return null;
    end;

    function get_doctor_by_extern_id(
        p_id number
    ) return LEBEDEV_MA.T_DOCTORS
    as
        v_item LEBEDEV_MA.T_DOCTORS;
    begin
        select LEBEDEV_MA.T_DOCTORS(
            surname => doc.SURNAME,
            name => doc.NAME,
            patronymic => doc.PATRONYMIC,
            gender => gen.NAME,
            spec_name => spec.NAME,
            salary => doc.SALARY,
            area => doc.AREA,
            rating => doc.RATING,
            id_extern_sys => doc.ID_EXTERN_SYS
        ) into v_item
        from LEBEDEV_MA.DOCTORS doc
            join LEBEDEV_MA.GENDER gen on doc.ID_GENDER = gen.ID_GENDER
            join LEBEDEV_MA.SPECIALITY spec on doc.ID_SPECIALITY = spec.ID_SPECIALITY
        where doc.ID_EXTERN_SYS = p_id;
        return v_item;
    exception
        when no_data_found then
            DBMS_OUTPUT.PUT_LINE('Такого доктора не существует');
        return null;
    end;
end;