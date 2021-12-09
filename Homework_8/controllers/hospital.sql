--Контроллер больнниц
create or replace function LEBEDEV_MA.controller_hospital
return clob
as
    v_result integer;
    v_response LEBEDEV_MA.T_ARR_HOSPITALS := LEBEDEV_MA.T_ARR_HOSPITALS();
    v_return_clob clob;
begin
    v_response := LEBEDEV_MA.SERVICE_HOSPITALS(
        out_result => v_result
    );
    v_return_clob := LEBEDEV_MA.PKG_RESOURCES.HOSPITAL();
    return v_return_clob;
end;