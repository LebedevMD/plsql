--Репозиторий больницы
create or replace function LEBEDEV_MA.repository_hospital(
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
        p_url => 'http://virtserver.swaggerhub.com/AntonovAD/DoctorDB/1.0.0/hospitals',
        p_debug => true,
        out_success => v_success,
        out_code => v_code
    );

    out_result := case when v_success
        then LEBEDEV_MA.pkg_code.c_ok
        else LEBEDEV_MA.pkg_code.c_error
    end;
    return v_clob;
end;