--Репозиторий докторов
create or replace package LEBEDEV_MA.repository_doctor
as
    --Получение данных "извне"
    function get_from_another_system(
        out_result out number
    )
    return clob;

    --Десериализация
    function deserialization(
        p_clob clob,
        out_result out number
    )
    return LEBEDEV_MA.t_arr_doctors_dto;

    --Мердж в таблицу
    procedure merge(
        p_arr_doctors LEBEDEV_MA.t_arr_doctors_dto,
        out_result out number
    );
end;

create or replace package body LEBEDEV_MA.repository_doctor
as
    function get_from_another_system(
        out_result out number
    )
    return clob
    as
        v_success boolean;
        v_code number;
        v_clob clob;
    begin
        DBMS_OUTPUT.ENABLE();
        v_clob := LEBEDEV_MA.HTTP_FETCHER_GET(
            p_url => 'http://virtserver.swaggerhub.com/AntonovAD/DoctorDB/1.0.0/doctors',
            p_debug => true,
            out_success => v_success,
            out_code => v_code
        );

        out_result := case when v_success
            then LEBEDEV_MA.pkg_codes.c_ok
            else LEBEDEV_MA.pkg_codes.c_error
        end;
        if (out_result = LEBEDEV_MA.PKG_CODES.C_ERROR) then
            LEBEDEV_MA.add_error_log( p_object_name => 'LEBEDEV_MA.repository_doctor.get_from_another_system',
                       p_params => '{"error":"' || sqlerrm
                        ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                        ||'"}');
        end if;
        return v_clob;
    end;

    function deserialization(
        p_clob clob,
        out_result out number
    )
    return LEBEDEV_MA.t_arr_doctors_dto
    as
        v_response LEBEDEV_MA.t_arr_doctors_dto := LEBEDEV_MA.T_ARR_DOCTORS_DTO();
    begin
        select LEBEDEV_MA.t_doctor_dto(
            id_doctor => r.id_doctor,
            id_hospital => r.id_hospital,
            surname => r.lname,
            name => r.fname,
            patronymic => r.mname
        )
        bulk collect into v_response
        from json_table(p_clob, '$' columns(
            nested path '$[*]' columns(
                id_doctor number path '$.id_doctor',
                id_hospital number path '$.id_hospital',
                lname varchar2(100) path '$.lname',
                fname varchar2(100) path '$.fname',
                mname varchar2(100) path '$.mname'
        ))) r;
        out_result := LEBEDEV_MA.PKG_CODES.C_OK;
        return v_response;
    exception
        when others then
        begin
            DBMS_OUTPUT.PUT_LINE(sqlerrm);
            LEBEDEV_MA.add_error_log( 'LEBEDEV_MA.repository_doctor.deserialization',
                       '{"error":"' || sqlerrm
                        ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                        ||'"}',
                'common',
                p_clob);
            out_result := LEBEDEV_MA.PKG_CODES.C_ERROR;
            return v_response;
        end;
    end;

    procedure merge(
        p_arr_doctors LEBEDEV_MA.t_arr_doctors_dto,
        out_result out number
    )
    as
    begin
        for i in p_arr_doctors.first..p_arr_doctors.LAST
        loop
            declare
                v_item LEBEDEV_MA.T_DOCTOR_DTO;
            begin
                v_item := p_arr_doctors(i);
                if (LEBEDEV_MA.PKG_DOCTORS.GET_DOCTOR_BY_EXTERN_ID(v_item.ID_DOCTOR) is null) then
                    LEBEDEV_MA.pkg_doctors.add_doctor_extern(v_item);
                end if;
            end;
        end loop;
        out_result := LEBEDEV_MA.PKG_CODES.C_OK;
    exception
        when others then
        begin
            DBMS_OUTPUT.PUT_LINE(sqlerrm);
            LEBEDEV_MA.add_error_log( 'LEBEDEV_MA.repository_doctor.merge',
                       '{"error":"' || sqlerrm
                        ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                        ||'"}');
            out_result := LEBEDEV_MA.PKG_CODES.C_ERROR;
        end;
    end;
end;
