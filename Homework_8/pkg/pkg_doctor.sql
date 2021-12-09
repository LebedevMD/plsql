--Часть пакета с методом добавления Докторов
create or replace package LEBEDEV_MA.pkg_doctors
as
    procedure add_arr(
        v_response T_ARR_DOCTORS
    );
end;

create or replace package body LEBEDEV_MA.PKG_DOCTORS
as
    procedure add_arr(
        v_response T_ARR_DOCTORS
    ) as
    begin
        for i in v_response.first..v_response.LAST
        loop
            declare
                v_item LEBEDEV_MA.T_DOKTOR;
            begin
                v_item := v_response(i);
                insert into LEBEDEV_MA.DOCTORS
                (
                 SURNAME,
                 NAME,
                 PATRONYMIC,
                 ID_HOSPITAL
                 )
                 values
                 (
                  v_item.SURNAME,
                  v_item.NAME,
                  v_item.PATRONYMIC,
                  v_item.ID_HOSPITAL
                 );
            end;
        end loop;
    end;
end;