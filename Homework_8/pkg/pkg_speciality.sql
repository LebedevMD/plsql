--Часть пакета с методом добавления специальностей
create or replace package LEBEDEV_MA.PKG_SPECIALITY
as
    procedure add_arr(
        v_response T_ARR_SPECIALITY
    );
end;

create or replace package body LEBEDEV_MA.PKG_SPECIALITY
as
    procedure add_arr(
        v_response T_ARR_SPECIALITY
    ) as
    begin
        for i in v_response.first..v_response.LAST
        loop
            declare
                v_item LEBEDEV_MA.T_SPECIAL;
            begin
                v_item := v_response(i);
                insert into LEBEDEV_MA.SPECIALITY
                (
                 name,
                 id_hospital
                 )
                 values
                 (
                  v_item.NAME,
                  v_item.ID_HOSPITAL
                 );
            end;
        end loop;
    end;
end;