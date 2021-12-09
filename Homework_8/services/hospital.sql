--Сервис больниц
create or replace function LEBEDEV_MA.service_hospitals(
    out_result out number
)
return LEBEDEV_MA.t_arr_hospitals
as
    v_result integer;
    v_clob clob;
    v_response LEBEDEV_MA.t_arr_hospitals := LEBEDEV_MA.t_arr_hospitals();
begin
    v_clob := LEBEDEV_MA.REPOSITORY_HOSPITAL(
        out_result => v_result
    );
    select LEBEDEV_MA.t_hosp(
        id_hospital => r.id_hospital,
        id_town => r.id_town,
        address => r.address,
        name => r.name
    )
    bulk collect into v_response
    from json_table(v_clob, '$' columns(
        nested path '$[*]' columns(
            id_hospital number path '$.id_hospital',
            id_town number path '$.id_town',
            name varchar2(300) path '$.name',
            address varchar2(500) path '$.address'
    ))) r;
    out_result := v_result;
    LEBEDEV_MA.PKG_HOSPITALS.add_arr(v_response);
    return v_response;
end;
