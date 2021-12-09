--Сервис специальности
create or replace function LEBEDEV_MA.service_speciality(
    out_result out number
)
return LEBEDEV_MA.t_arr_speciality
as
    v_result integer;
    v_clob clob;
    v_response LEBEDEV_MA.t_arr_speciality := LEBEDEV_MA.t_arr_speciality();
begin

    v_clob := LEBEDEV_MA.REPOSITORY_SPECIALITY(
        out_result => v_result
    );
    select LEBEDEV_MA.t_special(
        id_specialty => r.id_specialty,
        name => r.name,
        id_hospital => r.id_hospital
    )
    bulk collect into v_response
    from json_table(v_clob, '$' columns(
        nested path '$[*]' columns(
            id_specialty number path '$.id_specialty',
            name varchar2(100) path '$.name',
            id_hospital number path '$.id_hospital'
    ))) r;
    out_result := v_result;
    LEBEDEV_MA.PKG_SPECIALITY.add_arr(v_response);
    return v_response;
end;

