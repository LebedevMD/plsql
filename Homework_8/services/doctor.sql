--Сервис докторов
create or replace function LEBEDEV_MA.service_doctors(
    out_result out number
)
return LEBEDEV_MA.t_arr_doctors
as
    v_result integer;
    v_clob clob;
    v_response LEBEDEV_MA.t_arr_doctors := LEBEDEV_MA.t_arr_doctors();
begin

    v_clob := LEBEDEV_MA.REPOSITORY_DOCTORS(
        out_result => v_result
    );
    select LEBEDEV_MA.t_doktor(
        id_doctor => r.id_doctor,
        id_hospital => r.id_hospital,
        surname => r.lname,
        name => r.fname,
        patronymic => r.mname
    )
    bulk collect into v_response
    from json_table(v_clob, '$' columns(
        nested path '$[*]' columns(
            id_doctor number path '$.id_doctor',
            id_hospital number path '$.id_hospital',
            lname varchar2(100) path '$.lname',
            fname varchar2(100) path '$.fname',
            mname varchar2(100) path '$.mname'
    ))) r;
    out_result := v_result;
    LEBEDEV_MA.PKG_DOCTORS.add_arr(v_response);
    return v_response;
end;