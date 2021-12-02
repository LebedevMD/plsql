--Больница
create or replace type LEBEDEV_MA.t_hospital as object(
    med_organisation varchar2(999),
    isAvailable number,
    type_name varchar2(25),
    address varchar2(500)
);

alter type LEBEDEV_MA.t_hospital
add constructor function t_hospital(
    med_organisation varchar2,
    isAvailable number,
    type_name varchar2,
    address varchar2
) return self as result
cascade;

create or replace type body LEBEDEV_MA.t_hospital
as
constructor function t_hospital(
    med_organisation varchar2,
    isAvailable number,
    type_name varchar2,
    address varchar2
) return self as result
    as
    begin
        self.med_organisation := med_organisation;
        self.isAvailable := isAvailable;
        self.type_name := type_name;
        self.address := address;
        return;
    end;
end;

create or replace type LEBEDEV_MA.t_arr_hospitals as table of LEBEDEV_MA.T_HOSPITAL;