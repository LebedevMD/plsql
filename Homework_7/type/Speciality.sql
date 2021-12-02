--Специальность
create or replace type LEBEDEV_MA.t_speciality as object (
    name varchar2(50),
    req_gender varchar2(20),
    req_age_start_interval number,
    req_age_end_interval number
);

alter type LEBEDEV_MA.T_SPECIALITY
add constructor function t_speciality(
    name varchar2,
    req_gender varchar2,
    req_age_start_interval number default 18,
    req_age_end_interval number default 99
) return self as result
cascade;

create or replace type body LEBEDEV_MA.t_speciality
as
constructor function t_speciality(
    name varchar2,
    req_gender varchar2,
    req_age_start_interval number default 18,
    req_age_end_interval number default 99
) return self as result
    as
    begin
        self.name := name;
        self.req_gender := req_gender;
        self.req_age_start_interval := req_age_start_interval;
        self.req_age_end_interval := req_age_end_interval;
        return;
    end;
end;

create or replace type LEBEDEV_MA.t_arr_speciality as table of LEBEDEV_MA.T_SPECIALITY;