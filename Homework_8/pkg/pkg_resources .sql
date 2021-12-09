--Ресурсы
create or replace package LEBEDEV_MA.pkg_resources
as
    function doctor return clob;
    function speciality return clob;
    function hospital return clob;
end;

create or replace package body LEBEDEV_MA.pkg_resources
as
    function doctor
    return clob as
        v_json json_object_t := json_object_t();
        v_response LEBEDEV_MA.t_arr_doctors := LEBEDEV_MA.t_arr_doctors();
        v_json_response json_array_t := json_array_t();
        v_result integer;
        v_return_clob clob;
    begin
        v_json.put('code', v_result);
        if v_response.count>0 then
        for i in v_response.first..v_response.last
        loop
        declare
            v_item LEBEDEV_MA.t_doktor := v_response(i);
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

    function hospital
    return clob as
        v_json json_object_t := json_object_t();
        v_response LEBEDEV_MA.T_ARR_HOSPITALS := LEBEDEV_MA.T_ARR_HOSPITALS();
        v_json_response json_array_t := json_array_t();
        v_result integer;
        v_return_clob clob;
    begin
        v_json.put('code', v_result);
        if v_response.count>0 then
        for i in v_response.first..v_response.last
        loop
        declare
            v_item LEBEDEV_MA.T_HOSP := v_response(i);
            v_object json_object_t := json_object_t();
        begin
            v_object.put('id_hospital', v_item.id_hospital);
            v_object.put('id_town', v_item.id_town);
            v_object.put('name', v_item.name);
            v_object.put('address', v_item.address);

            v_json_response.append(v_object);
        end;
        end loop;
        end if;
        v_json.put('response', v_json_response);
        v_return_clob := v_json.to_Clob();
        return v_return_clob;
    end;

    function speciality
    return clob as
        v_json json_object_t := json_object_t();
        v_response LEBEDEV_MA.T_ARR_SPECIALITY := LEBEDEV_MA.T_ARR_SPECIALITY();
        v_json_response json_array_t := json_array_t();
        v_result integer;
        v_return_clob clob;
    begin
        v_json.put('code', v_result);
        if v_response.count>0 then
        for i in v_response.first..v_response.last
        loop
        declare
            v_item LEBEDEV_MA.t_special := v_response(i);
            v_object json_object_t := json_object_t();
        begin
            v_object.put('id_specialty', v_item.id_specialty);
            v_object.put('name', v_item.name);
            v_object.put('id_hospital', v_item.id_hospital);

            v_json_response.append(v_object);
        end;
        end loop;
        end if;
        v_json.put('response', v_json_response);
        v_return_clob := v_json.to_Clob();
        return v_return_clob;
    end;
end;