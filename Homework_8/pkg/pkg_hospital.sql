--Часть пакета с методом добавления больниц
create or replace package LEBEDEV_MA.PKG_HOSPITALS
as
    procedure add_arr(
        v_response T_ARR_HOSPITALS
    );
end;

create or replace package body LEBEDEV_MA.PKG_HOSPITALS
as
    procedure add_arr(
        v_response T_ARR_HOSPITALS
    ) as
    begin
        for i in v_response.first..v_response.LAST
        loop
            declare
                v_item LEBEDEV_MA.t_hosp;
            begin
                v_item := v_response(i);
                insert into LEBEDEV_MA.HOSPITALS
                (
                 name,
                 address,
                 id_town
                 )
                 values
                 (
                  v_item.NAME,
                  v_item.ADDRESS,
                  v_item.ID_TOWN
                 );
            end;
        end loop;
    end;
end;