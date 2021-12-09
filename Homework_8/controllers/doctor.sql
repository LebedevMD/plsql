--Контроллер докторов
create or replace function LEBEDEV_MA.controller_doctor
return clob
as
    v_result integer;
    v_response LEBEDEV_MA.t_arr_doctors := LEBEDEV_MA.t_arr_doctors();
    v_return_clob clob;
begin
    v_response := LEBEDEV_MA.SERVICE_DOCTORS(
        out_result => v_result
    );
    v_return_clob := LEBEDEV_MA.PKG_RESOURCES.DOCTOR();
    return v_return_clob;
end;