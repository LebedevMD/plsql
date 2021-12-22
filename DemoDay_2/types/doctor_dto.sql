--Доктор (ДТО для сериализации)
create or replace type LEBEDEV_MA.t_doctor_dto as object(
    id_doctor number,
    id_hospital number,
    surname varchar2(100),
    name varchar2(100),
    patronymic varchar2(100)
);

alter type LEBEDEV_MA.t_doctor_dto
add constructor function t_doctor_dto(
    id_doctor number,
    id_hospital number,
    surname varchar2,
    name varchar2,
    patronymic varchar2
) return self as result
cascade;

create or replace type body LEBEDEV_MA.t_doctor_dto
as
constructor function t_doctor_dto(
    id_doctor number,
    id_hospital number,
    surname varchar2,
    name varchar2,
    patronymic varchar2
) return self as result
    as
    begin
        self.id_doctor := id_doctor;
        self.id_hospital := id_hospital;
        self.name := name;
        self.surname := surname;
        self.patronymic := patronymic;
        return;
    end;
end;

create or replace type LEBEDEV_MA.t_arr_doctors_dto as table of LEBEDEV_MA.t_doctor_dto;