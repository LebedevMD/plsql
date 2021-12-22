--Контроллер докторов
create or replace function LEBEDEV_MA.controller_doctor
return clob
as
    v_json json_object_t := json_object_t();
    v_response LEBEDEV_MA.t_arr_doctors_dto := LEBEDEV_MA.t_arr_doctors_dto();
    v_json_response json_array_t := json_array_t();
    v_result integer;
    v_return_clob clob;
    v_result integer;
    v_response LEBEDEV_MA.t_arr_doctors_dto := LEBEDEV_MA.t_arr_doctors_dto();
    v_return_clob clob;
begin
    v_response := LEBEDEV_MA.SERVICE_DOCTORS(
        out_result => v_result
    );

    v_json.put('code', v_result);
    if v_response.count>0 then
    for i in v_response.first..v_response.last
    loop
    declare
        v_item LEBEDEV_MA.t_doctor_dto := v_response(i);
        v_object json_object_t := json_object_t();
    begin
        v_object.put('id_doctor', v_item.id_doctor);
        v_object.put('id_hospital', v_item.id_hospital);
        v_object.put('lname', v_item.SURNAME);
        v_object.put('fname', v_item.NAME);
        v_object.put('mname', v_item.PATRONYMIC);

        v_json_response.append(v_object);
    end;
    end loop;
    end if;
    v_json.put('response', v_json_response);
    v_return_clob := v_json.to_Clob();
    return v_return_clob;
end;