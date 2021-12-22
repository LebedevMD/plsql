--Сервис докторов
create or replace function LEBEDEV_MA.service_doctors(
    out_result out number
)
return LEBEDEV_MA.t_arr_doctors_dto
as
    v_result integer;
    v_clob clob;
    v_response LEBEDEV_MA.t_arr_doctors_dto := LEBEDEV_MA.t_arr_doctors_dto();
begin
    v_clob := LEBEDEV_MA.REPOSITORY_DOCTOR.get_from_another_system(
        out_result => v_result
    );
    select LEBEDEV_MA.t_doctor_dto(
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
    return v_response;
end;