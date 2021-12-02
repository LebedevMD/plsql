--Расписание
create or replace type LEBEDEV_MA.t_schedule as object(
    dayOfWeek varchar2(11),
    start_work date,
    end_work date
);

alter type LEBEDEV_MA.t_schedule
add constructor function t_schedule(
    dayOfWeek varchar2,
    start_work date,
    end_work date
) return self as result
cascade;

create or replace type body LEBEDEV_MA.t_schedule
as
constructor function t_schedule(
    dayOfWeek varchar2,
    start_work date,
    end_work date
) return self as result
    as
    begin
        self.dayOfWeek := dayOfWeek;
        self.start_work := start_work;
        self.end_work := end_work;
        return;
    end;
end;

create or replace type LEBEDEV_MA.t_arr_hospital_schedule as table of LEBEDEV_MA.t_schedule;