--Контроллер специальности
create or replace function LEBEDEV_MA.controller_speciality
return clob
as
    v_result integer;
    v_response LEBEDEV_MA.T_ARR_SPECIALITY := LEBEDEV_MA.T_ARR_SPECIALITY();
    v_return_clob clob;
begin
    v_response := LEBEDEV_MA.SERVICE_SPECIALITY(
        out_result => v_result
    );
    v_return_clob := LEBEDEV_MA.PKG_RESOURCES.SPECIALITY();
    return v_return_clob;
end;

