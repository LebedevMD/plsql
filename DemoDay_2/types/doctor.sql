--Доктор (тип целиком)
create or replace type LEBEDEV_MA.t_doctors as object(
    surname varchar2(100),
    name varchar2(100),
    patronymic varchar2(100),
    gender varchar2(20),
    spec_name varchar2(50),
    salary number,
    area number,
    rating number,
    id_extern_sys number
);

alter type LEBEDEV_MA.t_doctors
add constructor function t_doctors(
    surname varchar2,
    name varchar2,
    patronymic varchar2,
    gender varchar2,
    spec_name varchar2,
    salary number,
    area number,
    rating number default 0,
    id_extern_sys number
) return self as result
cascade;

create or replace type body LEBEDEV_MA.t_doctors
as
constructor function t_doctors(
    surname varchar2,
    name varchar2,
    patronymic varchar2,
    gender varchar2,
    spec_name varchar2,
    salary number,
    area number,
    rating number default 0,
    id_extern_sys number
) return self as result
    as
    begin
        self.name := name;
        self.surname := surname;
        self.patronymic := patronymic;
        self.gender := gender;
        self.spec_name := spec_name;
        self.salary := salary;
        self.area := area;
        self.rating := rating;
        self.id_extern_sys := id_extern_sys;
        return;
    end;
end;

create or replace type LEBEDEV_MA.t_arr_doctors as table of LEBEDEV_MA.T_DOCTORS;